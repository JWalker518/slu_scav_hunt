import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/main.dart';
import 'package:slu_scav_hunt/screens/discovery_screen.dart';

void main() {
  testWidgets('App should start and show Discovery Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: We don't initialize Firebase here as it's handled in main(), 
    // and for widget tests we usually override providers.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the Discovery Screen is shown.
    expect(find.byType(HuntDiscoveryScreen), findsOneWidget);
    expect(find.text('Discover Hunts'), findsOneWidget);
  });
}
