import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/domain/models/user.dart';
import '../../wallet/domain/models/transaction.dart';
import '../../wallet/domain/services/wallet_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key, required this.user, required this.wallet});

  final User user;
  final WalletService wallet;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Currency _currency = Currency.usd;
  int _periodDays = 30;

  List<Transaction> get _transactions => widget.wallet.transactions
      .where(
        (transaction) =>
            transaction.userId == widget.user.id &&
            transaction.currency == _currency,
      )
      .toList();

  double _delta(Transaction transaction) => switch (transaction.type) {
    TransactionType.deposit ||
    TransactionType.transferIn ||
    TransactionType.loanDisbursement => transaction.amount,
    TransactionType.withdrawal ||
    TransactionType.transferOut ||
    TransactionType.savingsInvestment ||
    TransactionType.loanRepayment => -transaction.amount,
  };

  List<DateTime> _sampleDates(DateTime now) {
    if (_periodDays == 365) {
      return List.generate(
        12,
        (index) => DateTime(now.year, now.month - 11 + index, 1),
      );
    }
    return List.generate(
      _periodDays == 7 ? 7 : 30,
      (index) => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: (_periodDays == 7 ? 6 : 29) - index)),
    );
  }

  List<double> _balancePoints(DateTime now) {
    final transactions = _transactions;
    final currentBalance = widget.wallet
        .balanceFor(widget.user.id, _currency)
        .amount;
    final totalDelta = transactions.fold<double>(
      0,
      (sum, transaction) => sum + _delta(transaction),
    );
    final startingBalance = currentBalance - totalDelta;
    final dates = _sampleDates(now);
    return dates.map((date) {
      final endOfDay = DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
        999,
      );
      final delta = transactions
          .where((transaction) => !transaction.createdAt.isAfter(endOfDay))
          .fold<double>(0, (sum, transaction) => sum + _delta(transaction));
      return startingBalance + delta;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dates = _sampleDates(DateTime.now());
    final values = _balancePoints(DateTime.now());
    final current = widget.wallet.balanceFor(widget.user.id, _currency).amount;
    final first = values.first;
    final change = current - first;
    final minimum = values.reduce((a, b) => math.min(a, b).toDouble());
    final maximum = values.reduce((a, b) => math.max(a, b).toDouble());
    final range = maximum - minimum;
    final padding = range == 0
        ? math.max(maximum.abs() * .08, 1).toDouble()
        : range * .18;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Analyses financières',
          style: TextStyle(
            color: context.appText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Évolution du solde selon votre historique disponible.',
          style: TextStyle(color: context.appMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final currency in Currency.values)
              _ChoiceChip(
                label: currency.code,
                selected: _currency == currency,
                onTap: () => setState(() => _currency = currency),
              ),
            for (final period in const [7, 30, 365])
              _ChoiceChip(
                label: period == 365 ? '12 mois' : '$period jours',
                selected: _periodDays == period,
                onTap: () => setState(() => _periodDays = period),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currency.format(current),
                style: TextStyle(
                  color: context.appText,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${change >= 0 ? '+' : ''}${_currency.format(change)} '
                'sur la période',
                style: TextStyle(
                  color: change >= 0
                      ? context.appAccent
                      : theme.colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (values.length - 1).toDouble(),
                    minY: minimum - padding,
                    maxY: maximum + padding,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: .6,
                        ),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 3,
                        color: theme.colorScheme.primary,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withValues(
                            alpha: .12,
                          ),
                        ),
                        spots: [
                          for (var index = 0; index < values.length; index++)
                            FlSpot(index.toDouble(), values[index]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${dates.first.day.toString().padLeft(2, '0')}/'
                    '${dates.first.month.toString().padLeft(2, '0')}',
                    style: TextStyle(color: context.appMuted, fontSize: 10),
                  ),
                  Text(
                    '${dates.last.day.toString().padLeft(2, '0')}/'
                    '${dates.last.month.toString().padLeft(2, '0')}',
                    style: TextStyle(color: context.appMuted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Le graphique présente une estimation à partir des opérations locales '
          'disponibles. Il ne constitue pas un relevé bancaire.',
          style: TextStyle(color: context.appMuted, fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    showCheckmark: false,
    onSelected: (_) => onTap(),
    labelStyle: TextStyle(
      color: selected
          ? Theme.of(context).colorScheme.onPrimary
          : context.appMuted,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    ),
    selectedColor: Theme.of(context).colorScheme.primary,
    backgroundColor: context.appCard,
    side: BorderSide(color: context.appBorder),
  );
}
