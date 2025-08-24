from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel
from supabase import create_client
from datetime import datetime
import json, os, asyncio, uuid

# Supabase credentials
SUPABASE_URL = "https://qsfsjpbphblntpbrecvu.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzZnNqcGJwaGJsbnRwYnJlY3Z1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NTU5NDIsImV4cCI6MjA3MTMzMTk0Mn0.qdziCjrezyhAJfaOfmbW1mmZ_lnHaXsjvPdGI8KmvM8"  # replace with your anon key
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
app = FastAPI()

# Queue file
QUEUE_FILE = "offline_queue.json"
flush_lock = asyncio.Lock()

# Pydantic model
class Transaction(BaseModel):
    from_user: str
    to_user: str
    amount: int
    status: str = "queued"

# Helpers
def normalize_tx(tx):
    """Add unique ID and timestamp"""
    return {
        "id": tx.get("id", str(uuid.uuid4())),
        "from_user": str(tx["from_user"]),
        "to_user": str(tx["to_user"]),
        "amount": int(tx["amount"]),
        "status": tx.get("status", "queued"),
        "timestamp": datetime.utcnow().isoformat()
    }

def load_queue():
    if os.path.exists(QUEUE_FILE):
        with open(QUEUE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return []

def save_queue(queue):
    with open(QUEUE_FILE, "w", encoding="utf-8") as f:
        json.dump(queue, f, default=str, indent=2)

def deduplicate_queue(queue):
    """Remove duplicates based on 'id'"""
    seen = set()
    unique = []
    for tx in queue:
        if tx["id"] not in seen:
            seen.add(tx["id"])
            unique.append(tx)
    return unique

# Insert with offline support
def try_insert(prepared_txs):
    """Attempt to insert into Supabase; queue if offline or fails"""
    try:
        resp = supabase.table("transactions").upsert(prepared_txs, on_conflict="id").execute()
        if getattr(resp, "error", None):
            raise Exception(resp.error)
        print("Inserted to Supabase:", getattr(resp, "data", resp))
        return True
    except Exception as e:
        print("Supabase insert failed, saving to queue:", e)
        queue = load_queue()
        queue.extend(prepared_txs)
        queue = deduplicate_queue(queue)
        save_queue(queue)
        return False

# Flush queued transactions
def flush_queue():
    """Insert queued transactions safely with upsert"""
    queue = load_queue()
    if not queue:
        return
    try:
        resp = supabase.table("transactions").upsert(queue, on_conflict="id").execute()
        if getattr(resp, "error", None):
            raise Exception(resp.error)
        print(f"Flushed {len(queue)} queued transactions successfully.")
        save_queue([])  # clear queue immediately
    except Exception as e:
        print("Flush failed, keeping transactions in queue:", e)

# POST endpoint: read JSON file and insert
@app.post("/transactions_from_file/")
async def create_transaction_from_file(background_tasks: BackgroundTasks):
    try:
        with open("trans.json", "r", encoding="utf-8") as f:
            transactions = json.load(f)
    except Exception as e:
        return {"ok": False, "reason": "could not read trans.json", "error": str(e)}

    if isinstance(transactions, dict):
        transactions = [transactions]

    prepared = []
    for i, tx in enumerate(transactions):
        try:
            Transaction(**tx)
            prepared.append(normalize_tx(tx))
        except Exception as e:
            return {"ok": False, "reason": f"validation error at item {i}", "error": str(e)}

    success = try_insert(prepared)
    if not success:
        background_tasks.add_task(flush_queue)

    return {
        "ok": True,
        "inserted_now": success,
        "queued_for_later": not success,
        "tx_count": len(prepared)
    }

# Auto flush queued transactions every 30 seconds
@app.on_event("startup")
async def start_periodic_flush():
    async def periodic_flush():
        while True:
            async with flush_lock:
                try:
                    flush_queue()
                except Exception as e:
                    print("Error flushing queue:", e)
            await asyncio.sleep(30)
    asyncio.create_task(periodic_flush())