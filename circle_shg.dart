import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:math';
import '../theme/app_colors.dart';

class CircleSGHPage extends StatefulWidget {
  const CircleSGHPage({super.key});

  @override
  State<CircleSGHPage> createState() => _CircleSGHPageState();
}

class _CircleSGHPageState extends State<CircleSGHPage> {
  // A list of groups with their members and state
  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Group 1',
      'members': [
        {'name': 'Anagha', 'paid': true, 'won': false},
        {'name': 'Aishwariya', 'paid': true, 'won': false},
        {'name': 'Harshitha', 'paid': false, 'won': false},
        {'name': 'Gokul', 'paid': false, 'won': false},
      ],
      'winnerIndex': -1,
      'Month': 1,
    },
    {
      'name': 'Group 2',
      'members': [
        {'name': 'Alice', 'paid': true, 'won': false},
        {'name': 'Bob', 'paid': true, 'won': false},
        {'name': 'Charlie', 'paid': true, 'won': false},
        {'name': 'David', 'paid': false, 'won': false},
      ],
      'winnerIndex': -1,
      'Month': 1,
    },
    {
      'name': 'Group 3',
      'members': [
        {'name': 'Priya', 'paid': true, 'won': false},
        {'name': 'Sanjay', 'paid': false, 'won': false},
        {'name': 'Tanya', 'paid': true, 'won': false},
        {'name': 'Vikram', 'paid': false, 'won': false},
      ],
      'winnerIndex': -1,
      'Month': 1,
    },
  ];

  void _start(int groupIndex) {
    setState(() {
      final group = _groups[groupIndex];

      // Cast members to a typed list to avoid dynamic/closure type issues
      final List<Map<String, dynamic>> members =
      List<Map<String, dynamic>>.from(group['members'] as List);

      // Get a list of members who have not yet won (use explicit boolean compare)
      final eligibleMembers = members.where((member) => member['won'] == false).toList();

      if (eligibleMembers.isEmpty) {
        // Reset the group if everyone has had a turn
        for (var member in members) {
          member['won'] = false;
        }
        _showInfo('All members have won! The group has been reset.');
        group['Month'] = 1;
        return;
      }

      final random = Random();
      final winnerIndex = random.nextInt(eligibleMembers.length);
      final winner = eligibleMembers[winnerIndex];

      // Update the winner status in the original group
      final originalWinnerIndex = members.indexOf(winner);
      // write back to the untyped underlying structure
      group['members'][originalWinnerIndex]['won'] = true;
      group['winnerIndex'] = originalWinnerIndex;
      group['Month'] = (group['Month'] as int) + 1;
      _showInfo('${winner['name']} has won the bid for this month!');
    });
  }

  void _showInfo(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: neonGreen)),
          backgroundColor: darkBackground,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Self Help Groups',
          style: TextStyle(fontFamily: 'Orbitron', color: neonGreen),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: neonGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          final members = List<Map<String, dynamic>>.from(group['members'] as List);
          final winnerIndex = group['winnerIndex'];
          final totalAmount = members.where((m) => m['paid']).length * 50;

          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: neonGreen.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${group['name']} - Month ${group['Month']}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contribution: Rs 50/member',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  'Total Pot: Rs $totalAmount',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(members.length, (memberIndex) {
                    final member = members[memberIndex];
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: member['paid'] ? Colors.greenAccent : Colors.redAccent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: neonGreen.withOpacity(0.2),
                            child: Icon(
                              PhosphorIcons.user(PhosphorIconsStyle.bold),
                              color: member['paid'] ? Colors.greenAccent : Colors.redAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          member['name'],
                          style: TextStyle(
                              color: member['paid'] ? Colors.white : Colors.white54,
                              fontWeight: winnerIndex == memberIndex ? FontWeight.bold : FontWeight.normal),
                        ),
                        if (winnerIndex == memberIndex)
                          Text(
                            'Winner!',
                            style: TextStyle(color: Colors.yellowAccent, fontSize: 12),
                          ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _start(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(
                        color: darkBackground,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}