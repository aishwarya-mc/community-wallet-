import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // New import for network status
import '../theme/app_colors.dart';

// You need this helper function for the box shadow, assuming it's not
// in another file. If it is, you can remove this.
List<BoxShadow> getNeonGlow(Color color) {
  return [
    BoxShadow(
      color: color.withOpacity(0.6),
      blurRadius: 15,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];
}

// The page is now a StatelessWidget that receives the user's name and phone number.
class DashboardPage extends StatelessWidget {
  // These variables are now part of the constructor.
  final String userName;
  final String userPhone;

  const DashboardPage({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/send');
        },
        backgroundColor: neonGreen,
        child: const Icon(Icons.send, color: darkBackground),
        shape: const CircleBorder(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildNavBar(context),
              const SizedBox(height: 30),
              _buildBalanceCard(context),
              const SizedBox(height: 30),
              _buildSentTodayCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $userName', // Now uses the userName variable
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Orbitron',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userPhone, // Now uses the userPhone variable
              style: TextStyle(
                color: neonGreen.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
        // This widget is now responsible for detecting and displaying the network status.
        _buildOnlineStatus(),
      ],
    );
  }

  Widget _buildOnlineStatus() {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final isOnline = snapshot.data != ConnectivityResult.none;
        final color = isOnline ? neonGreen : Colors.red;
        final statusText = isOnline ? 'Online' : 'Offline';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, color: color, size: 10),
              const SizedBox(width: 6),
              Text(
                statusText,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  // Now accepts BuildContext to allow for navigation
  Widget _buildNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: neonGreen.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Corrected syntax for filled icons
          _navBarItem(context, PhosphorIcons.wallet(PhosphorIconsStyle.fill), 'Wallet', '/dashboard', isSelected: true),
          _navBarItem(context, PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill), 'Send', '/send'),
          _navBarItem(context, PhosphorIcons.clock(PhosphorIconsStyle.fill), 'History', '/history'),
          _navBarItem(context, PhosphorIcons.users(PhosphorIconsStyle.fill), 'Contacts', '/contacts'),
          // New navigation item for "Circle"
          _navBarItem(context, PhosphorIcons.circle(PhosphorIconsStyle.fill), 'Circle', '/circle'),
        ],
      ),
    );
  }

  // Now accepts BuildContext and route name
  Widget _navBarItem(BuildContext context, IconData icon, String label, String routeName, {bool isSelected = false}) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Container(
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 8)
            : null,
        decoration: isSelected
            ? BoxDecoration(
          color: neonGreen,
          borderRadius: BorderRadius.circular(20),
        )
            : null,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? darkBackground : Colors.white, size: 20),
            if (isSelected) const SizedBox(width: 8),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  color: darkBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: neonGreen.withOpacity(0.7)),
        boxShadow: getNeonGlow(neonGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Icon(
                PhosphorIcons.copy(PhosphorIconsStyle.regular),
                color: Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Rs 2,847.50',
            style: TextStyle(
              color: neonGreen,
              fontSize: 48,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 15.0,
                  color: neonGreen.withOpacity(0.7),
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/send');
                  },
                  icon: Icon(
                    PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill),
                    color: darkBackground,
                  ),
                  label: const Text('Send Money', style: TextStyle(color: darkBackground, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/request');
                  },
                  icon: Icon(
                    PhosphorIcons.arrowDownLeft(PhosphorIconsStyle.regular),
                    color: Colors.white,
                  ),
                  label: const Text('Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSentTodayCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: neonGreen.withOpacity(0.7)),
        boxShadow: getNeonGlow(neonGreen.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: neonGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              PhosphorIcons.arrowUpRight(PhosphorIconsStyle.regular),
              color: neonGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sent Today', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(height: 4),
              Text('Rs 135.49', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}