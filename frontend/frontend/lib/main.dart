import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/account_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.status == AuthStatus.authenticated) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}