import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slu_scav_hunt/widgets/location_rationale_dialog.dart';

void main() {
  testWidgets('LocationRationaleDialog shows correct text for foreground', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LocationRationaleDialog(),
      ),
    );

    expect(find.text('Location Access Needed'), findsOneWidget);
    expect(find.textContaining('This app needs access to your location'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.text('CONTINUE'), findsOneWidget);
  });

  testWidgets('LocationRationaleDialog shows correct text for background', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LocationRationaleDialog(isBackground: true),
      ),
    );

    expect(find.text('Background Location Access'), findsOneWidget);
    expect(find.textContaining('This app collects location data to enable tracking'), findsOneWidget);
  });
}
