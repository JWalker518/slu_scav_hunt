import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:slu_scav_hunt/firebase_options.dart';
import 'package:slu_scav_hunt/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes the Firebase App, typically called before any FlutterFire plugin is used
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Wraps app in a widget that stores the state of the provider 
    // Called before riverpod plugins
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunt',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hunt'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Hunt App!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
