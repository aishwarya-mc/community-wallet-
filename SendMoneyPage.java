import 'package:flutter/material.dart';
import '../theme.dart';

class SendMoneyPage extends StatelessWidget {
  const SendMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Send Money', style: TextStyle(fontFamily: 'Orbitron', color: neonGreen)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: neonGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Send Money Page - To be built',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}