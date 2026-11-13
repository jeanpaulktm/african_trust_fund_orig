import 'package:african/features/auth/presentation/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('registration screen exposes client and mandatory proxy fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(
          onClientLogin: (_) {},
          onAdminLogin: () {},
          onRegister: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Nouveau client ? Créer un compte'));
    await tester.pumpAndSettle();

    expect(find.text('Vos informations'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(find.text('Téléphone et adresse'), findsOneWidget);
    expect(find.text('Numéro de téléphone'), findsOneWidget);
    expect(find.text('Ville'), findsOneWidget);
    expect(find.text('Commune'), findsOneWidget);
    expect(find.text('Quartier'), findsOneWidget);
    expect(find.text('Cellule'), findsOneWidget);
    expect(find.text('Numéro de maison'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('Photo de profil et identité'), findsOneWidget);
    expect(find.text('Photo de profil'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(find.text('Recto de la pièce'), findsOneWidget);
    expect(find.text('Verso de la pièce'), findsOneWidget);
    expect(find.text('Aucune image'), findsAtLeastNWidgets(1));
    expect(find.text('Photo de profil (nom du fichier)'), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Votre mandataire'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Pièce d’identité du mandataire'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Créer mon compte'), findsOneWidget);
  });
}
