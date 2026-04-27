import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:slu_scav_hunt/screens/login_screen.dart';
import 'package:slu_scav_hunt/services/auth_service.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    // Return a stream that doesn't emit anything by default
    when(() => mockAuthService.authStateChanges).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('LoginScreen shows email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });
}
