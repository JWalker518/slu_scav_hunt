import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/main.dart';
import 'package:slu_scav_hunt/widgets/auth_gate.dart';
import 'package:slu_scav_hunt/providers/theme_provider.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getInt(any())).thenReturn(null);
  });

  testWidgets('App should start and show AuthGate', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          // Override authStateProvider to prevent Firebase initialization
          authStateProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(AuthGate), findsOneWidget);
  });
}
