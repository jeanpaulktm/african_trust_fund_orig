import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/domain/models/user.dart';
import '../domain/services/wallet_service.dart';

class BalancesPage extends StatelessWidget {
  const BalancesPage({super.key, required this.user, required this.wallet});

  final User user;
  final WalletService wallet;

  @override
  Widget build(BuildContext context) {
    final usd = wallet.balanceFor(user.id, Currency.usd).amount;
    final cdf = wallet.balanceFor(user.id, Currency.cdf).amount;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Mes soldes',
          style: TextStyle(
            color: context.appText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Vos comptes et leur équivalent au taux administrateur.',
          style: TextStyle(color: context.appMuted, fontSize: 13),
        ),
        const SizedBox(height: 22),
        _BalanceCard(
          currency: Currency.usd,
          amount: usd,
          convertedAmount: usd * wallet.usdToCdfRate,
          convertedCurrency: Currency.cdf,
          icon: Icons.attach_money_rounded,
        ),
        const SizedBox(height: 14),
        _BalanceCard(
          currency: Currency.cdf,
          amount: cdf,
          convertedAmount: cdf / wallet.usdToCdfRate,
          convertedCurrency: Currency.usd,
          icon: Icons.account_balance_wallet_outlined,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: context.appAccent),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Taux indicatif : 1 USD = ${wallet.usdToCdfRate.toStringAsFixed(2)} CDF. '
                  'Les virements utilisent ce taux au moment de la transaction.',
                  style: TextStyle(
                    color: context.appMuted,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.currency,
    required this.amount,
    required this.convertedAmount,
    required this.convertedCurrency,
    required this.icon,
  });

  final Currency currency;
  final double amount;
  final double convertedAmount;
  final Currency convertedCurrency;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(21),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: Theme.of(context).brightness == Brightness.dark
            ? const [Color(0xFFE2B84B), Color(0xFFF4D782)]
            : const [Color(0xFF087A52), Color(0xFF20A66F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(23),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          blurRadius: 18,
          offset: Offset(0, 9),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                currency.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary
                      .withValues(alpha: 0.82),
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              currency.code,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          currency.format(amount),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '≈ ${convertedCurrency.format(convertedAmount)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary
                .withValues(alpha: 0.82),
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
