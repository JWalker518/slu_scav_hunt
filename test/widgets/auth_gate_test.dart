import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slu_scav_hunt/widgets/auth_gate.dart';
import 'package:slu_scav_hunt/screens/login_screen.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';
import 'package:slu_scav_hunt/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}
class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('AuthGate shows LoginScreen when user is null', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
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
