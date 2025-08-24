import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_colors.dart';

// The page is now a StatefulWidget to manage the amount entered and make network calls.
class RequestMoneyPage extends StatefulWidget {
  const RequestMoneyPage({super.key});

  @override
  State<RequestMoneyPage> createState() => _RequestMoneyPageState();
}

class _RequestMoneyPageState extends State<RequestMoneyPage> {
  String _amount = ''; // The state variable to store the entered amount.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Request Money',
          style: TextStyle(fontFamily: 'Orbitron', color: neonGreen),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: neonGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildContactList(),
              const SizedBox(height: 30),
              _buildAmountInput(),
              const SizedBox(height: 30),
              _buildKeypad(),
              const SizedBox(height: 20),
              _buildRequestButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: neonGreen.withOpacity(0.2),
                      child: Icon(
                        PhosphorIcons.user(PhosphorIconsStyle.bold), // IconData from factory
                        color: neonGreen,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Name',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      children: [
        const Text(
          'Enter Amount',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          // The amount is now dynamically updated
          _amount.isEmpty ? '\$0.00' : '\$${_amount}',
          style: TextStyle(
            color: neonGreen,
            fontSize: 48,
            fontFamily: 'Orbitron',
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: neonGreen.withOpacity(0.5),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypad() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final List<String> keypadValues = [
          '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'
        ];
        return ElevatedButton(
          onPressed: () {
            // This logic updates the amount on the screen
            _onKeypadPressed(keypadValues[index]);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            keypadValues[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        );
      },
    );
  }

  void _onKeypadPressed(String value) {
    setState(() {
      if (value == '⌫') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else if (value == '.') {
        if (!_amount.contains('.')) {
          _amount = '$_amount.';
        }
      } else {
        _amount = '$_amount$value';
      }
    });
  }

  Widget _buildRequestButton() {
    return ElevatedButton(
      onPressed: _amount.isNotEmpty ? () async {
        // Replace with your ngrok URL
        const String ngrokUrl = 'https://05cdf8748aba.ngrok-free.app';

        try {
          final response = await http.post(
            Uri.parse('$ngrokUrl/transactions_from_file/'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'amount': double.tryParse(_amount) ?? 0.0,
              'type': 'request',
              // You may need to add sender/receiver info here
            }),
          );

          if (response.statusCode == 200) {
            // Success! You can show a message or navigate back.
            Navigator.of(context).pop();
            print('Request sent successfully!');
          } else {
            print('Server error: ${response.statusCode}');
          }
        } catch (e) {
          print('Error: $e');
        }
      } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _amount.isNotEmpty ? neonGreen : neonGreen.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'REQUEST',
        style: TextStyle(
            color: darkBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
