import 'package:african/core/money/currency.dart';
import 'package:african/features/admin/presentation/admin_page.dart';
import 'package:african/features/auth/domain/models/mandataire.dart';
import 'package:african/features/auth/domain/models/user.dart';
import 'package:african/features/wallet/domain/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'admin can inspect clients and operation journal, then update rate',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final client = User(
        id: 'client-1',
        lastName: 'Kadeghu',
        postName: 'Mbuyi',
        firstName: 'Nehemie',
        email: 'nehemie@example.cd',
        dateOfBirth: DateTime(1995, 6, 12),
        identityNumber: 'ID-001',
        profilePhotoPath: 'profile.jpg',
        passwordHash: 'pending-server-authentication',
        mandataire: const Mandataire(
          fullName: 'Grace Mbuyi',
          contact: '+243000000000',
          relationship: 'Soeur',
        ),
      );
      final wallet = WalletService(
        usdToCdfRate: 2800,
        initialBalances: {
          client.id: {Currency.usd: 100},
        },
      );
      wallet.deposit(userId: client.id, currency: Currency.usd, amount: 25);

      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(clients: [client], wallet: wallet, onSignOut: () {}),
        ),
      );

      expect(find.text('1 USD = 2800.00 CDF'), findsOneWidget);
      await tester.tap(find.text('Clients'));
      await tester.pumpAndSettle();
      expect(find.text('nehemie@example.cd'), findsOneWidget);

      await tester.tap(find.text('Opérations'));
      await tester.pumpAndSettle();
      expect(find.text('Dépôt'), findsOneWidget);

      await tester.tap(find.text('Vue générale'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Modifier le taux'));
      await tester.tap(find.text('Modifier le taux'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '2900');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();
      expect(wallet.usdToCdfRate, 2900);
      expect(find.text('1 USD = 2900.00 CDF'), findsOneWidget);
    },
  );
}
