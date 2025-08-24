from fastapi import FastAPI, HTTPException, Query
from typing import List, Optional
from supabase import create_client
from pydantic import BaseModel

SUPABASE_URL = "https://qsfsjpbphblntpbrecvu.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzZnNqcGJwaGJsbnRwYnJlY3Z1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NTU5NDIsImV4cCI6MjA3MTMzMTk0Mn0.qdziCjrezyhAJfaOfmbW1mmZ_lnHaXsjvPdGI8KmvM8"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
app = FastAPI()

class TransactionOut(BaseModel):
    id: str
    from_user: str
    to_user: str
    amount: int
    status: str
    timestamp: Optional[str]

@app.get("/")
async def root():
    return {"message": "Claim Transaction API is running - UPDATED VERSION"}

@app.get("/claim_transactions/", response_model=List[TransactionOut])
async def claim_transactions(
    to_user: str = Query(..., description="Username who is claiming their transactions (to_user)"),
    limit: int = Query(10, ge=1, le=100, description="Max number of transactions to claim at once")
):
    try:
        print(f"=== DEBUG: Starting claim_transactions for user: {to_user}, limit: {limit} ===")
        
        # First, let's see all transactions for this user (any status)
        all_user_transactions = (
            supabase
            .table("transactions")
            .select("id,from_user,to_user,amount,status,timestamp")
            .eq("to_user", to_user)
            .execute()
        )
        print(f"DEBUG: All transactions for {to_user}: {all_user_transactions.data}")

        # Select candidate rows that are PENDING for this user
        sel = (
            supabase
            .table("transactions")
            .select("id,from_user,to_user,amount,status,timestamp")
            .eq("to_user", to_user)
            .eq("status", "pending")
            .order("timestamp", desc=False)
            .limit(limit)
            .execute()
        )

        candidates = sel.data or []
        print(f"DEBUG: Found {len(candidates)} PENDING transactions for {to_user}")
        print(f"DEBUG: Candidates: {candidates}")
        
        if not candidates:
            print(f"DEBUG: No PENDING transactions found for {to_user}")
            return []

        ids = [c["id"] for c in candidates]
        print(f"DEBUG: IDs to update: {ids}")

        # Update those ids to status='confirmed' (only if still pending)
        upd = (
            supabase
            .table("transactions")
            .update({"status": "confirmed"})
            .in_("id", ids)           
            .eq("status", "pending")   
            .execute()
        )

        print(f"DEBUG: Update operation completed")

        # Fetch the updated rows
        updated_result = (
            supabase
            .table("transactions")
            .select("id,from_user,to_user,amount,status,timestamp")
            .in_("id", ids)
            .execute()
        )

        updated_rows = updated_result.data or []
        print(f"DEBUG: Fetched {len(updated_rows)} rows after update")
        print(f"DEBUG: Updated rows: {updated_rows}")

        return updated_rows

    except Exception as e:
        print(f"DEBUG: Exception occurred: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")