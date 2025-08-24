import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_colors.dart';

// The page is now a StatefulWidget to handle text input
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                PhosphorIcons.atom(PhosphorIconsStyle.bold),
                color: neonGreen,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                'Arceus Pay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: neonGreen,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: 60),

              // Name TextField
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: neonGreen.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.person, color: neonGreen),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: neonGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: neonGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number TextField
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: neonGreen.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.phone, color: neonGreen),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: neonGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: neonGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // PIN TextField
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'PIN',
                  labelStyle: TextStyle(color: neonGreen.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.lock, color: neonGreen),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: neonGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: neonGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Login Button now navigates directly
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context,
                      '/dashboard',
                      arguments: {
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                      }
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: neonGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      color: darkBackground,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}