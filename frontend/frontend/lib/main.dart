import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.status == AuthStatus.authenticated) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Welcome, ${auth.userName ?? "User"}'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => auth.logout(),
                  ),
                ],
              ),
              body: const Center(
                child: Text('Dashboard Coming Soon!', style: TextStyle(fontSize: 20)),
              ),
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}