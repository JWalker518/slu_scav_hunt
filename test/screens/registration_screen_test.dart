import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/screens/registration_screen.dart';

void main() {
  testWidgets('RegistrationScreen shows fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Register'), findsWidgets);
  });
}
