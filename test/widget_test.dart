import 'package:african/core/money/currency.dart';
import 'package:african/features/dashboard/presentation/dashboard_page.dart';
import 'package:african/features/wallet/domain/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'dashboard does not change balance before a provider confirms withdrawal',
    (tester) async {
      final wallet = WalletService(
        usdToCdfRate: 2800,
        initialBalances: {
          'user-001': {Currency.usd: 1250, Currency.cdf: 820000},
        },
      );

      await tester.pumpWidget(MaterialApp(home: DashboardPage(wallet: wallet)));

      expect(find.text('Solde total'), findsOneWidget);
      expect(find.text('1 250,00 USD'), findsOneWidget);

      await tester.tap(find.text('Retirer'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('mobile-money-phone')),
        '+243812345678',
      );
      await tester.enterText(
        find.byKey(const ValueKey('operation-amount')),
        '100',
      );
      await tester.pump();
      expect(find.text('1,00 USD'), findsOneWidget);

      await tester.tap(find.text('Continuer avec l’opérateur'));
      await tester.pumpAndSettle();

      expect(wallet.balanceFor('user-001', Currency.usd).amount, 1250);
      expect(find.text('1 250,00 USD'), findsOneWidget);
      expect(
        find.textContaining('Aucun paiement ni retrait n’a été effectué.'),
        findsOneWidget,
      );
      expect(wallet.transactions, isEmpty);
    },
  );
}
