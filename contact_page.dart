import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_colors.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  // A hard-coded list of contact names.
  final List<String> contactNames = const [
    'Anagha',
    'Manu',
    'Aishwariya',
    'Harshitha',
    'Gokul',
    'pranav',
    'tanya',
    'nivetha',
    'bob',
    'diya',
    'preeta',
    'rajesh',
    'cuk',
    'sowdamini',
    'menon',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Contacts',
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
          itemCount: contactNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: neonGreen.withOpacity(0.2),
                child: Icon(
                    PhosphorIcons.user(PhosphorIconsStyle.bold),
                    color: neonGreen
                ),
              ),
              title: Text(
                contactNames[index],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '+1 (555) 555-010${index + 1}', // Static phone number for now
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(
                    PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill),
                    color: neonGreen
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/send');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}