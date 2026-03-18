import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/screens/hunt_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  testWidgets('HuntDetailScreen displays all hunt details', (WidgetTester tester) async {
    final hunt = Hunt(
      id: '1',
      title: 'Detailed Hunt',
      description: 'Full description of the hunt.',
      creatorName: 'James',
      difficulty: 'Medium',
      rating: 4.2,
      coordinates: const GeoPoint(44.0, -75.0),
      riddle: 'The secret riddle text',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HuntDetailScreen(hunt: hunt),
      ),
    );

    expect(find.text('Detailed Hunt'), findsNWidgets(2)); // AppBar and Title
    expect(find.text('Full description of the hunt.'), findsOneWidget);
    expect(find.text('The secret riddle text'), findsOneWidget);
    expect(find.text('Created by James'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(find.text('START HUNT'), findsOneWidget);
  });
}
