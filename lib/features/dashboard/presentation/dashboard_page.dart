import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../payments/domain/models/payment_result.dart';
import '../../payments/domain/models/withdrawal_ticket.dart';
import '../../payments/domain/services/payment_gateway.dart';
import '../../wallet/domain/models/transaction.dart';
import '../../wallet/domain/services/wallet_service.dart';
import 'widgets/withdrawal_ticket_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.wallet,
    this.paymentGateway = const UnavailablePaymentGateway(),
    this.phoneNumber = '',
    this.userId = 'user-001',
    this.firstName = 'Nehemie',
  });

  final WalletService wallet;
  final PaymentGateway paymentGateway;
  final String phoneNumber;
  final String userId;
  final String firstName;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Currency _currency = Currency.usd;

  double get _balance =>
      widget.wallet.balanceFor(widget.userId, _currency).amount;

  List<Transaction> get _recentTransactions => widget.wallet.transactions
      .where((transaction) => transaction.userId == widget.userId)
      .take(5)
      .toList();

  @override
  Widget build(BuildContext context) {
    final otherCurrency = _currency == Currency.usd
        ? Currency.cdf
        : Currency.usd;
    final convertedBalance = _currency == Currency.usd
        ? _balance * widget.wallet.usdToCdfRate
        : _balance / widget.wallet.usdToCdfRate;

    return Scaffold(
      backgroundColor: context.appSurface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
          children: [
            _buildHeader(),
            const SizedBox(height: 28),
            Text(
              'Solde total',
              style: TextStyle(
                color: context.appMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _DashboardEntrance(
              child: _buildBalanceCard(otherCurrency, convertedBalance),
            ),
            const SizedBox(height: 24),
            _buildCurrencyPicker(),
            const SizedBox(height: 24),
            _DashboardEntrance(
              child: Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      expanded: false,
                      label: 'Déposer',
                      icon: Icons.add_rounded,
                      onPressed: () => _showMoneyDialog(withdrawal: false),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GradientButton(
                      expanded: false,
                      label: 'Retirer',
                      icon: Icons.north_east_rounded,
                      onPressed: () => _showMoneyDialog(withdrawal: true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activité récente',
                  style: TextStyle(
                    color: context.appText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Taux: 1 USD = ${widget.wallet.usdToCdfRate.toStringAsFixed(0)} CDF',
                  style: TextStyle(
                    color: context.appMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (_recentTransactions.isEmpty)
              const _EmptyActivity()
            else
              ..._recentTransactions.map(
                (transaction) => _TransactionTile(transaction: transaction),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue',
                style: TextStyle(
                  color: context.appText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Bonjour, ${widget.firstName}',
                style: TextStyle(color: context.appMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(Currency otherCurrency, double convertedBalance) {
    const foreground = Colors.white;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isDarkMode
              ? const [Color(0xFF243665), Color(0xFF111A3A)]
              : const [Color(0xFF087A52), Color(0xFF20A66F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Portefeuille principal',
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.82),
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(Icons.more_horiz_rounded, color: foreground, size: 25),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            _currency.format(_balance),
            style: TextStyle(
              color: foreground,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '≈ ${otherCurrency.format(convertedBalance)}',
            style: TextStyle(
              color: foreground.withValues(alpha: 0.82),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Icon(Icons.shield_outlined, color: foreground, size: 16),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Compte sécurisé',
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.88),
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                widget.userId.toUpperCase(),
                style: TextStyle(
                  color: foreground.withValues(alpha: 0.72),
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyPicker() {
    return Row(
      children: Currency.values.map((currency) {
        final selected = currency == _currency;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ChoiceChip(
            label: Text(currency.code),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _currency = currency),
            labelStyle: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : context.appMuted,
              fontWeight: FontWeight.w700,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: context.appCard,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showMoneyDialog({required bool withdrawal}) async {
    final completed = await showDialog<_MoneyOperationOutcome>(
      context: context,
      builder: (_) => _MoneyDialog(
        currency: _currency,
        withdrawal: withdrawal,
        userId: widget.userId,
        phoneNumber: widget.phoneNumber,
        paymentGateway: widget.paymentGateway,
      ),
    );

    if (completed == null || !mounted) return;
    if (completed.ticket != null) {
      await showDialog<void>(
        context: context,
        builder: (_) => WithdrawalTicketDialog(ticket: completed.ticket!),
      );
      return;
    }

    final result = completed.paymentResult;
    if (result == null) return;
    if (result.status == PaymentStatus.succeeded) setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.reference == null
              ? result.message
              : '${result.message} Référence : ${result.reference}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _DashboardEntrance extends StatelessWidget {
  const _DashboardEntrance({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 520),
    curve: Curves.easeOutCubic,
    builder: (context, progress, child) => Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 14 * (1 - progress)),
        child: child,
      ),
    ),
    child: child,
  );
}

class _MoneyDialog extends StatefulWidget {
  const _MoneyDialog({
    required this.currency,
    required this.withdrawal,
    required this.userId,
    required this.phoneNumber,
    required this.paymentGateway,
  });

  final Currency currency;
  final bool withdrawal;
  final String userId;
  final String phoneNumber;
  final PaymentGateway paymentGateway;

  @override
  State<_MoneyDialog> createState() => _MoneyDialogState();
}

class _MoneyDialogState extends State<_MoneyDialog> {
  final _controller = TextEditingController();
  late final TextEditingController _phoneController;
  MobileMoneyProvider _provider = MobileMoneyProvider.mpesa;
  String _method = 'mobile';
  String? _errorText;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = double.tryParse(
      _controller.text.trim().replaceAll(',', '.'),
    );
    final fee = parsed != null && parsed > 0
        ? (parsed * WalletService.withdrawalFeeRate * 100).round() / 100
        : 0.0;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.withdrawal ? 'Nouveau retrait' : 'Nouveau dépôt'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.withdrawal) ...[
              const Text('Choisissez votre mode de retrait.'),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'mobile',
                    label: Text('Mobile Money'),
                    icon: Icon(Icons.phone_android_rounded),
                  ),
                  ButtonSegment(
                    value: 'counter',
                    label: Text('Guichet'),
                    icon: Icon(Icons.storefront_outlined),
                  ),
                ],
                selected: {_method},
                onSelectionChanged: _submitting
                    ? null
                    : (selection) => setState(() {
                        _method = selection.first;
                        _errorText = null;
                      }),
              ),
              const SizedBox(height: 14),
            ],
            if (!widget.withdrawal || _method == 'mobile') ...[
              DropdownButtonFormField<MobileMoneyProvider>(
                initialValue: _provider,
                decoration: const InputDecoration(labelText: 'Opérateur'),
                items: MobileMoneyProvider.values
                    .map(
                      (provider) => DropdownMenuItem(
                        value: provider,
                        child: Text(provider.label),
                      ),
                    )
                    .toList(),
                onChanged: _submitting
                    ? null
                    : (provider) {
                        if (provider != null) {
                          setState(() => _provider = provider);
                        }
                      },
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('mobile-money-phone'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Numéro Mobile Money',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '+243...',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Une demande sera envoyée à l’opérateur. Validez uniquement '
                'dans son menu sécurisé; ne communiquez jamais votre PIN ou OTP.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Un bordereau avec QR code sera créé après validation du '
                  'serveur. Le guichetier le scannera avant de remettre les espèces.',
                  style: TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Text(
              'Montant en ${widget.currency.code}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const ValueKey('operation-amount'),
              controller: _controller,
              autofocus: !widget.withdrawal,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() => _errorText = null),
              decoration: InputDecoration(
                hintText: '0,00',
                suffixText: widget.currency.code,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (widget.withdrawal) ...[
              const SizedBox(height: 14),
              _FeeRow(label: 'Frais (1 %)', value: widget.currency.format(fee)),
              const SizedBox(height: 5),
              _FeeRow(
                label: 'Total débité',
                value: widget.currency.format((parsed ?? 0) + fee),
                emphasized: true,
              ),
            ],
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.withdrawal
                      ? _method == 'counter'
                            ? 'Créer le bordereau'
                            : 'Continuer avec l’opérateur'
                      : 'Continuer avec l’opérateur',
                ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(
      _controller.text.trim().replaceAll(',', '.'),
    );
    if (amount == null || !amount.isFinite || amount <= 0) {
      setState(() => _errorText = 'Saisissez un montant valide.');
      return;
    }

    if (_method == 'mobile' && !_validPhone(_phoneController.text)) {
      setState(() => _errorText = 'Saisissez un numéro Mobile Money valide.');
      return;
    }

    setState(() => _submitting = true);
    try {
      if (widget.withdrawal && _method == 'counter') {
        final fee =
            (amount * WalletService.withdrawalFeeRate * 100).round() / 100;
        final ticket = await widget.paymentGateway.createCounterWithdrawal(
          userId: widget.userId,
          currency: widget.currency,
          amount: amount,
          fee: fee,
        );
        if (mounted) {
          Navigator.pop(context, _MoneyOperationOutcome(ticket: ticket));
        }
        return;
      }

      final result = widget.withdrawal
          ? await widget.paymentGateway.withdrawByMobileMoney(
              userId: widget.userId,
              phoneNumber: _phoneController.text.trim(),
              provider: _provider,
              currency: widget.currency,
              amount: amount,
              fee:
                  (amount * WalletService.withdrawalFeeRate * 100).round() /
                  100,
            )
          : await widget.paymentGateway.depositByMobileMoney(
              userId: widget.userId,
              phoneNumber: _phoneController.text.trim(),
              provider: _provider,
              currency: widget.currency,
              amount: amount,
            );
      if (mounted) {
        Navigator.pop(context, _MoneyOperationOutcome(paymentResult: result));
      }
    } on ArgumentError catch (error) {
      if (mounted) setState(() => _errorText = error.message.toString());
    } on StateError catch (error) {
      if (mounted) setState(() => _errorText = error.message);
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _errorText = 'Opération non aboutie : $error');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool _validPhone(String value) => RegExp(r'\d').allMatches(value).length >= 7;
}

class _MoneyOperationOutcome {
  const _MoneyOperationOutcome({this.paymentResult, this.ticket});

  final PaymentResult? paymentResult;
  final WithdrawalTicket? ticket;
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final color = emphasized
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isIncoming =
        transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.transferIn ||
        transaction.type == TransactionType.loanDisbursement;
    final icon = switch (transaction.type) {
      TransactionType.deposit => Icons.south_west_rounded,
      TransactionType.withdrawal => Icons.north_east_rounded,
      TransactionType.transferIn => Icons.call_received_rounded,
      TransactionType.transferOut => Icons.call_made_rounded,
      TransactionType.savingsInvestment => Icons.savings_outlined,
      TransactionType.loanDisbursement => Icons.account_balance_rounded,
      TransactionType.loanRepayment => Icons.payments_outlined,
    };
    final title = switch (transaction.type) {
      TransactionType.deposit => 'Dépôt',
      TransactionType.withdrawal => 'Retrait',
      TransactionType.transferIn => 'Virement reçu',
      TransactionType.transferOut => 'Virement envoyé',
      TransactionType.savingsInvestment => 'Placement épargne',
      TransactionType.loanDisbursement => 'Décaissement crédit',
      TransactionType.loanRepayment => 'Remboursement crédit',
    };
    final date = transaction.createdAt;
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'
        ' • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isIncoming
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 19,
              color: isIncoming
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncoming ? '+' : '-'}${transaction.currency.format(transaction.amount)}',
                style: TextStyle(
                  color: isIncoming
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (transaction.fee > 0)
                Text(
                  'Frais: ${transaction.currency.format(transaction.fee)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'Aucune opération pour le moment.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
    );
  }
}
