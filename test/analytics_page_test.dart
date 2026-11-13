import 'package:african/core/money/currency.dart';
import 'package:african/features/analytics/presentation/analytics_page.dart';
import 'package:african/features/auth/domain/models/mandataire.dart';
import 'package:african/features/auth/domain/models/user.dart';
import 'package:african/features/wallet/domain/services/wallet_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('analytics shows a chart and selectable time periods', (
    tester,
  ) async {
    final user = User(
      id: 'client',
      lastName: 'Test',
      postName: '',
      firstName: 'Client',
      email: 'client@example.cd',
      dateOfBirth: DateTime(1995),
      identityNumber: 'ID-TEST',
      profilePhotoPath: '',
      identityFrontPath: '',
      identityBackPath: '',
      passwordHash: 'pending-server-authentication',
      mandataire: const Mandataire(
        fullName: 'Mandataire Test',
        contact: '000',
        relationship: 'Proche',
        identityDocumentPath: '',
      ),
    );
    final wallet = WalletService(
      usdToCdfRate: 2800,
      initialBalances: {
        user.id: {Currency.usd: 100},
      },
    );
    wallet.deposit(userId: user.id, currency: Currency.usd, amount: 25);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AnalyticsPage(user: user, wallet: wallet)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Analyses financières'), findsOneWidget);
    expect(find.text('30 jours'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('125,00 USD'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 450));
    await tester.pumpAndSettle();
    await tester.tap(find.text('7 jours'));
    await tester.pump();
    expect(find.text('7 jours'), findsOneWidget);
  });
}
