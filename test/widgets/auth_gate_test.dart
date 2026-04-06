import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slu_scav_hunt/widgets/auth_gate.dart';
import 'package:slu_scav_hunt/screens/login_screen.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  testWidgets('AuthGate shows LoginScreen when user is null', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(
          home: AuthGate(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
