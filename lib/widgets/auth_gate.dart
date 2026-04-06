import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../screens/login_screen.dart';
import '../screens/discovery_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        return const HuntDiscoveryScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
