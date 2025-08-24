import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_colors.dart';

// The page is now a StatelessWidget and does not fetch data from a backend.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A hard-coded list of names to display in the history.
    final List<String> historyNames = const [
      'Anagha',
      'Manu',
      'Preeta',
      'Rajesh',
      'Pranav',
      'Tanya',
      'Bob',
      'Diya',
      'Menon',
      'Anjali',
      'Arun',
      'Kiran',
      'Priya',
      'Rahul',
    ];

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(fontFamily: 'Orbitron', color: neonGreen),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: neonGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: historyNames.length, // Use the length of the list for the count
          itemBuilder: (context, index) {
            // This logic determines if it's a sent or received transaction.
            final bool isSent = index % 2 == 0;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: neonGreen.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: isSent ? Colors.red.withOpacity(0.3) : neonGreen.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isSent ? Colors.red.withOpacity(0.2) : neonGreen.withOpacity(0.2),
                    child: Icon(
                      // Corrected Phosphor icon syntax
                      isSent
                          ? PhosphorIcons.arrowUpRight(PhosphorIconsStyle.bold)
                          : PhosphorIcons.arrowDownLeft(PhosphorIconsStyle.bold),
                      color: isSent ? Colors.red : neonGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSent ? 'Sent to ${historyNames[index]}' : 'Received from ${historyNames[index]}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'June ${1 + index}, 2025',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    isSent ? '-\$${10.00 + index * 5}' : '+\$${15.00 + index * 5}',
                    style: TextStyle(
                      color: isSent ? Colors.red : neonGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}