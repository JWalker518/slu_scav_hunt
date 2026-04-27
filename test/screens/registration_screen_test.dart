import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:slu_scav_hunt/screens/registration_screen.dart';
import 'package:slu_scav_hunt/services/auth_service.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    when(() => mockAuthService.authStateChanges).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('RegistrationScreen shows fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Register'), findsWidgets);
  });
}
