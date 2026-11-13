import 'package:african/features/notifications/presentation/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('notification screen lists contextual demo notifications', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: NotificationScreen()));

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Dépôt reçu'), findsOneWidget);
    expect(find.text('Alerte de sécurité'), findsOneWidget);
    expect(find.text('Mise à jour de l’application'), findsOneWidget);
    expect(
      find.textContaining('Notifications de démonstration'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.south_west_rounded), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    expect(find.byIcon(Icons.system_update_alt_rounded), findsOneWidget);
  });
}
