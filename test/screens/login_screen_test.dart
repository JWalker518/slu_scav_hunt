import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen shows email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });
}
