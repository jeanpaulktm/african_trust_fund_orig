import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/domain/models/user.dart';
import '../domain/models/transaction.dart';
import '../domain/services/wallet_service.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({
    super.key,
    required this.user,
    required this.clients,
    required this.wallet,
  });

  final User user;
  final List<User> clients;
  final WalletService wallet;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    final transactions = widget.wallet.transactions
        .where((transaction) => transaction.userId == widget.user.id)
        .toList();
    final usd = widget.wallet.balanceFor(widget.user.id, Currency.usd).amount;
    final cdf = widget.wallet.balanceFor(widget.user.id, Currency.cdf).amount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        Text(
          'Mon portefeuille',
          style: TextStyle(
            color: context.appText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Consultez vos comptes et envoyez un virement.',
          style: TextStyle(color: context.appMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        _CurrencyBalanceCard(
          currency: Currency.usd,
          amount: usd,
          icon: Icons.attach_money_rounded,
          subtitle: 'Compte en dollar américain',
        ),
        const SizedBox(height: 12),
        _CurrencyBalanceCard(
          currency: Currency.cdf,
          amount: cdf,
          icon: Icons.account_balance_wallet_outlined,
          subtitle: 'Compte en franc congolais',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.appAccentSoft,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              Icon(Icons.currency_exchange, color: context.appAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Taux appliqué : 1 USD = ${widget.wallet.usdToCdfRate.toStringAsFixed(0)} CDF',
                  style: TextStyle(
                    color: context.appAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GradientButton(
          label: 'Effectuer un virement',
          icon: Icons.swap_horiz_rounded,
          onPressed:
              widget.clients
                  .where((client) => client.id != widget.user.id)
                  .isEmpty
              ? null
              : _showTransferDialog,
        ),
        const SizedBox(height: 27),
        Text(
          'Historique du portefeuille',
          style: TextStyle(
            color: context.appText,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          const _NoWalletActivity()
        else
          ...transactions.map(
            (transaction) => _WalletTransactionTile(transaction: transaction),
          ),
        const SizedBox(height: 24),
        const _SavingsAndCreditCard(),
      ],
    );
  }

  Future<void> _showTransferDialog() async {
    final recipients = widget.clients
        .where((client) => client.id != widget.user.id)
        .toList();
    if (recipients.isEmpty) return;

    final completed = await showDialog<bool>(
      context: context,
      builder: (_) => _TransferDialog(
        sender: widget.user,
        recipients: recipients,
        wallet: widget.wallet,
      ),
    );
    if (completed == true && mounted) {
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Virement enregistré.')));
    }
  }
}

class _TransferDialog extends StatefulWidget {
  const _TransferDialog({
    required this.sender,
    required this.recipients,
    required this.wallet,
  });

  final User sender;
  final List<User> recipients;
  final WalletService wallet;

  @override
  State<_TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<_TransferDialog> {
  final _amountController = TextEditingController();
  late User? _recipient;
  Currency _fromCurrency = Currency.usd;
  Currency _toCurrency = Currency.cdf;
  String? _error;

  @override
  void initState() {
    super.initState();
    _recipient = widget.recipients.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    final estimate = _fromCurrency == _toCurrency
        ? amount
        : _fromCurrency == Currency.usd
        ? amount * widget.wallet.usdToCdfRate
        : amount / widget.wallet.usdToCdfRate;
    return AlertDialog(
      title: const Text('Nouveau virement'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<User>(
              initialValue: _recipient,
              decoration: const InputDecoration(labelText: 'Destinataire'),
              items: widget.recipients
                  .map(
                    (client) => DropdownMenuItem(
                      value: client,
                      child: Text(client.fullName),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _recipient = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Currency>(
                    initialValue: _fromCurrency,
                    decoration: const InputDecoration(labelText: 'Depuis'),
                    items: Currency.values
                        .map(
                          (currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency.code),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _fromCurrency = value);
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 18, left: 8, right: 8),
                  child: Icon(Icons.arrow_forward_rounded, size: 18),
                ),
                Expanded(
                  child: DropdownButtonFormField<Currency>(
                    initialValue: _toCurrency,
                    decoration: const InputDecoration(labelText: 'Vers'),
                    items: Currency.values
                        .map(
                          (currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency.code),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _toCurrency = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() => _error = null),
              decoration: InputDecoration(
                labelText: 'Montant',
                suffixText: _fromCurrency.code,
              ),
            ),
            if (amount > 0) ...[
              const SizedBox(height: 10),
              Text(
                'Le destinataire recevra environ ${_toCurrency.format(estimate)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Confirmer')),
      ],
    );
  }

  void _submit() {
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    if (amount == null ||
        !amount.isFinite ||
        amount <= 0 ||
        _recipient == null) {
      setState(() => _error = 'Vérifiez les informations.');
      return;
    }

    try {
      widget.wallet.transfer(
        fromUserId: widget.sender.id,
        toUserId: _recipient!.id,
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
        amount: amount,
      );
      Navigator.pop(context, true);
    } on ArgumentError catch (error) {
      setState(() => _error = error.message.toString());
    } on StateError catch (error) {
      setState(() => _error = error.message);
    }
  }
}

class _CurrencyBalanceCard extends StatelessWidget {
  const _CurrencyBalanceCard({
    required this.currency,
    required this.amount,
    required this.icon,
    required this.subtitle,
  });

  final Currency currency;
  final double amount;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currency.code,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Text(
          currency.format(amount),
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _WalletTransactionTile extends StatelessWidget {
  const _WalletTransactionTile({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final incoming =
        transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.transferIn ||
        transaction.type == TransactionType.loanDisbursement;
    final title = switch (transaction.type) {
      TransactionType.deposit => 'Dépôt',
      TransactionType.withdrawal => 'Retrait',
      TransactionType.transferIn => 'Virement reçu',
      TransactionType.transferOut => 'Virement envoyé',
      TransactionType.savingsInvestment => 'Placement épargne',
      TransactionType.loanDisbursement => 'Décaissement crédit',
      TransactionType.loanRepayment => 'Remboursement crédit',
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            incoming ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: incoming
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title • ${transaction.createdAt.day}/${transaction.createdAt.month}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${incoming ? '+' : '-'}${transaction.currency.format(transaction.amount)}',
            style: TextStyle(
              color: incoming
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoWalletActivity extends StatelessWidget {
  const _NoWalletActivity();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(17),
    ),
    child: Text(
      'Vos opérations apparaîtront ici.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
    ),
  );
}

class _SavingsAndCreditCard extends StatelessWidget {
  const _SavingsAndCreditCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: context.appCard,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.savings_outlined, color: context.appAccent),
            const SizedBox(width: 9),
            Text(
              'Épargne & crédit',
              style: TextStyle(
                color: context.appText,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Accédez depuis le menu aux espaces Épargne, Crédit et Analyses.',
          style: TextStyle(color: context.appMuted, fontSize: 12, height: 1.5),
        ),
      ],
    ),
  );
}
