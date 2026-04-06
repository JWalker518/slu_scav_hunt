import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/main.dart';
import 'package:slu_scav_hunt/widgets/auth_gate.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';

void main() {
  testWidgets('App should start and show AuthGate', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(AuthGate), findsOneWidget);
  });
}
