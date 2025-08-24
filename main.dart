import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import all the necessary files for your app's pages and theme.
import 'package:arceus_pay/pages/dashboard_page.dart';
import 'package:arceus_pay/pages/login_page.dart';
import 'package:arceus_pay/pages/send_money_page.dart';
import 'package:arceus_pay/pages/contact_page.dart';
import 'package:arceus_pay/pages/history_page.dart';
import 'package:arceus_pay/pages/request_money_page.dart';
import 'package:arceus_pay/pages/circle_shg.dart'; // New Import
import 'package:arceus_pay/theme/app_colors.dart';

// Your Supabase URL and anon key go here.
// Get them from your Supabase project's API settings (Project Settings → API).
const String supabaseUrl = 'https://qsfsjpbphblntpbrecvu.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzZnNqcGJwaGJsbnRwYnJlY3Z1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NTU5NDIsImV4cCI6MjA3MTMzMTk0Mn0.qdziCjrezyhAJfaOfmbW1mmZ_lnHaXsjvPdGI8KmvM8';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const ArceusPayApp());
}

class ArceusPayApp extends StatelessWidget {
  const ArceusPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arceus Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Orbitron',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackground,
        primaryColor: neonGreen,
      ),
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) =>
        const DashboardPage(userName: 'User', userPhone: 'N/A'),
        '/send': (context) => const SendMoneyPage(),
        '/contacts': (context) => const ContactsPage(),
        '/history': (context) => const HistoryPage(),
        '/request': (context) => const RequestMoneyPage(),
        '/circle': (context) => const CircleSGHPage(), // New Route
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // If logged in, go to dashboard
        if (snapshot.hasData && snapshot.data!.session != null) {
          final user = snapshot.data!.session!.user;
          return DashboardPage(
            userName: user.userMetadata?['name'] ?? 'User',
            userPhone: user.userMetadata?['phone'] ?? 'N/A',
          );
        }
        // If not logged in, go to login page
        return const LoginPage();
      },
    );
  }
}