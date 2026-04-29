import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slu_scav_hunt/widgets/gameplay_status_card.dart';

void main() {
  Widget createWidget({
    bool isCompleted = false,
    double distance = 150.0,
    bool showDistance = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: GameplayStatusCard(
          isCompleted: isCompleted,
          distance: distance,
          showDistance: showDistance,
          onBack: () {},
        ),
      ),
    );
  }

  group('GameplayStatusCard Widget Tests', () {
    testWidgets('Should show exact distance when showDistance is true', (tester) async {
      await tester.pumpWidget(createWidget(showDistance: true, distance: 150.0));

      expect(find.text('Distance: 150m'), findsOneWidget);
      expect(find.text('Keep searching...'), findsOneWidget);
    });

    testWidgets('Should show proximity clue when showDistance is false', (tester) async {
      await tester.pumpWidget(createWidget(showDistance: false, distance: 150.0));

      expect(find.textContaining('Distance:'), findsNothing);
      expect(find.text("You're getting warmer!"), findsOneWidget);
    });

    testWidgets('Should show very close message when distance < 100', (tester) async {
      await tester.pumpWidget(createWidget(showDistance: true, distance: 50.0));

      expect(find.text('You are very close!'), findsOneWidget);
      expect(find.text('Distance: 50m'), findsOneWidget);
    });

    testWidgets('Should show very close message without distance when showDistance is false', (tester) async {
      await tester.pumpWidget(createWidget(showDistance: false, distance: 50.0));

      expect(find.text('You are very close!'), findsOneWidget);
      expect(find.textContaining('Distance:'), findsNothing);
    });

    testWidgets('Should show completion message when isCompleted is true', (tester) async {
      await tester.pumpWidget(createWidget(isCompleted: true));

      expect(find.text('CORRECT! YOU FOUND IT!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
