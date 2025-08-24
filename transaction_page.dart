import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final response = await supabase
        .from('transactions')
        .select()
        .order('timestamp', ascending: false); // latest first

    setState(() {
      transactions = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text("No transactions found"))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  tx['from_user'][0].toUpperCase(),
                ),
              ),
              title: Text(
                  "${tx['from_user']} → ${tx['to_user']}"),
              subtitle: Text(
                "Status: ${tx['status']}\n"
                    "Time: ${tx['timestamp']}",
              ),
              trailing: Text(
                "₹${tx['amount']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tx['status'] == "completed"
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}