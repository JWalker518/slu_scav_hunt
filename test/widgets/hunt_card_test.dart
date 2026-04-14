import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/widgets/hunt_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  testWidgets('HuntCard displays hunt details', (WidgetTester tester) async {
    final hunt = Hunt(
      id: '1',
      title: 'SLU Adventure',
      description: 'Find the hidden bells',
      creatorName: 'James',
      creatorId: 'test-creator-id',
      difficulty: 'Easy',
      rating: 4.8,
      coordinates: const GeoPoint(44.5912, -75.1667),
      riddle: 'Ring my bell',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HuntCard(hunt: hunt),
        ),
      ),
    );

    expect(find.text('SLU Adventure'), findsOneWidget);
    expect(find.text('Find the hidden bells'), findsOneWidget);
    expect(find.text('By James'), findsOneWidget);
    expect(find.text('EASY'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
  });
}
