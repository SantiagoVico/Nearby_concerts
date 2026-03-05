import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:excuses_as_a_service/main.dart'; 

void main() {
  testWidgets('Test de chargement de l\'écran principal', (WidgetTester tester) async {
    // On lance notre nouvelle application
    await tester.pumpWidget(const MaterialApp(home: ConcertListScreen()));

    // On vérifie que notre écran est bien là
    expect(find.byType(ConcertListScreen), findsOneWidget);
  });
}