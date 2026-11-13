import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/domain/models/user.dart';
import '../domain/models/savings_investment.dart';
import '../domain/services/savings_service.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key, required this.user, required this.savings});

  final User user;
  final SavingsService savings;

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  Currency _currency = Currency.usd;
  Timer? _refreshTimer;

  List<SavingsInvestment> get _investments =>
      widget.savings.investmentsFor(widget.user.id);

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const foreground = Colors.white;
    final investments = _investments;
    final principal = investments.fold<double>(
      0,
      (sum, item) => item.currency == _currency ? sum + item.principal : sum,
    );
    final earned = investments.fold<double>(
      0,
      (sum, item) => item.currency == _currency
          ? sum + item.interestAt(DateTime.now())
          : sum,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Mon épargne',
          style: TextStyle(
            color: context.appText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Placez une partie de votre solde et suivez son évolution.',
          style: TextStyle(color: context.appMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: context.isDarkMode
                  ? const [Color(0xFF243665), Color(0xFF111A3A)]
                  : const [Color(0xFF087A52), Color(0xFF20A66F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valeur de votre épargne • ${_currency.code}',
                style: TextStyle(
                  color: foreground.withValues(alpha: .8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _currency.format(principal + earned),
                style: TextStyle(
                  color: foreground,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Capital ${_currency.format(principal)}  •  Gains ${_currency.format(earned)}',
                style: TextStyle(
                  color: foreground.withValues(alpha: .85),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Taux annuel indicatif : '
                '${(widget.savings.annualInterestRate * 100).toStringAsFixed(2)} %',
                style: TextStyle(
                  color: foreground.withValues(alpha: .85),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        DropdownButtonFormField<Currency>(
          initialValue: _currency,
          decoration: const InputDecoration(labelText: 'Devise du placement'),
          items: Currency.values
              .map(
                (currency) => DropdownMenuItem(
                  value: currency,
                  child: Text('${currency.code} — ${currency.label}'),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _currency = value);
          },
        ),
        const SizedBox(height: 14),
        GradientButton(
          label: 'Placer un montant',
          icon: Icons.savings_outlined,
          onPressed: _showInvestDialog,
        ),
        const SizedBox(height: 26),
        Text(
          'Mes placements',
          style: TextStyle(
            color: context.appText,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (investments.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: context.appCard,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Vos placements et leurs intérêts apparaîtront ici.',
              style: TextStyle(color: context.appMuted, fontSize: 12),
            ),
          )
        else
          ...investments.map(_investmentCard),
        const SizedBox(height: 14),
        Text(
          'Estimation locale à intérêt simple, calculée depuis la date du placement. '
          'Le taux affiché est une valeur de démonstration, pas une offre contractuelle.',
          style: TextStyle(color: context.appMuted, fontSize: 11, height: 1.5),
        ),
      ],
    );
  }

  Widget _investmentCard(SavingsInvestment investment) {
    final earned = investment.interestAt(DateTime.now());
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.appAccentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.savings_outlined, color: context.appAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment.currency.format(investment.principal),
                  style: TextStyle(
                    color: context.appText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Depuis le ${investment.startedAt.day.toString().padLeft(2, '0')}/'
                  '${investment.startedAt.month.toString().padLeft(2, '0')}/'
                  '${investment.startedAt.year}',
                  style: TextStyle(color: context.appMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${investment.currency.format(earned)}',
                style: TextStyle(
                  color: context.appAccent,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              Text(
                '${(investment.annualInterestRate * 100).toStringAsFixed(2)} % / an',
                style: TextStyle(color: context.appMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showInvestDialog() async {
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nouveau placement'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Montant',
            suffixText: _currency.code,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = double.tryParse(
                controller.text.trim().replaceAll(',', '.'),
              );
              if (parsed == null || !parsed.isFinite || parsed <= 0) return;
              Navigator.pop(dialogContext, parsed);
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null || !mounted) return;

    try {
      widget.savings.invest(
        userId: widget.user.id,
        currency: _currency,
        amount: amount,
      );
      setState(() {});
    } on ArgumentError catch (error) {
      _showMessage(error.message.toString());
    } on StateError catch (error) {
      _showMessage(error.message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
