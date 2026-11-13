import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/atf_logo.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/domain/models/user.dart';
import '../../payments/domain/services/payment_gateway.dart';
import '../../payments/presentation/counter_withdrawal_scanner_page.dart';
import '../../wallet/domain/models/transaction.dart';
import '../../wallet/domain/services/wallet_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
    required this.clients,
    required this.wallet,
    required this.onSignOut,
    this.paymentGateway = const UnavailablePaymentGateway(),
    this.isDark = false,
    this.onToggleTheme,
  });

  final List<User> clients;
  final WalletService wallet;
  final PaymentGateway paymentGateway;
  final VoidCallback onSignOut;
  final bool isDark;
  final VoidCallback? onToggleTheme;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  static const _tabs = ['Vue générale', 'Clients', 'Opérations'];

  @override
  Widget build(BuildContext context) {
    final transactions = widget.wallet.transactions;
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: context.appSurface,
        appBar: AppBar(
          backgroundColor: context.appSurface,
          title: Row(
            children: [
              const AtfLogo(width: 96, height: 46, padding: 3),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Administration',
                      style: TextStyle(
                        color: context.appText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'African Trust Fund • Console',
                      style: TextStyle(color: context.appMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Déconnexion',
              onPressed: widget.onSignOut,
              icon: const Icon(Icons.logout_rounded),
            ),
            IconButton(
              tooltip: widget.isDark
                  ? 'Activer le mode clair'
                  : 'Activer le mode sombre',
              onPressed: widget.onToggleTheme,
              icon: Icon(
                widget.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverview(context, transactions),
            _buildClients(context),
            _buildOperations(context, transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(BuildContext context, List<Transaction> transactions) {
    final totalUsd = widget.clients.fold<double>(
      0,
      (total, client) =>
          total + widget.wallet.balanceFor(client.id, Currency.usd).amount,
    );
    final totalCdf = widget.clients.fold<double>(
      0,
      (total, client) =>
          total + widget.wallet.balanceFor(client.id, Currency.cdf).amount,
    );
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: context.isDarkMode
                  ? const [Color(0xFFE2B84B), Color(0xFFF4D782)]
                  : const [Color(0xFF087A52), Color(0xFF20A66F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.insights_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 25,
              ),
              SizedBox(height: 13),
              Text(
                'Vue du système',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Suivez les comptes, les opérations et les paramètres de change.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary
                      .withValues(alpha: 0.82),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        Wrap(
          spacing: 11,
          runSpacing: 11,
          children: [
            _MetricCard(
              label: 'Clients inscrits',
              value: '${widget.clients.length}',
              icon: Icons.people_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            _MetricCard(
              label: 'Opérations',
              value: '${transactions.length}',
              icon: Icons.receipt_long_outlined,
              color: const Color(0xFF25835B),
            ),
            _MetricCard(
              label: 'Soldes USD',
              value: Currency.usd.format(totalUsd),
              icon: Icons.attach_money_rounded,
              color: const Color(0xFF217E95),
            ),
            _MetricCard(
              label: 'Soldes CDF',
              value: Currency.cdf.format(totalCdf),
              icon: Icons.account_balance_wallet_outlined,
              color: const Color(0xFFB36B25),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Taux de change administrateur',
                style: TextStyle(
                  color: context.appText,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '1 USD = ${widget.wallet.usdToCdfRate.toStringAsFixed(2)} CDF',
                style: TextStyle(
                  color: context.appAccent,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              GradientButton(
                label: 'Modifier le taux',
                icon: Icons.currency_exchange_rounded,
                onPressed: _changeRate,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CounterWithdrawalScannerPage(
                paymentGateway: widget.paymentGateway,
              ),
            ),
          ),
          icon: const Icon(Icons.qr_code_scanner_rounded),
          label: const Text('Scanner un retrait au guichet'),
        ),
        const SizedBox(height: 20),
        Text(
          'Modules du système',
          style: TextStyle(
            color: context.appText,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        const _SystemModuleRow(
          icon: Icons.verified_user_outlined,
          title: 'Vérification KYC',
          subtitle: 'Dossiers clients et mandataires',
          state: 'En attente',
        ),
        const _SystemModuleRow(
          icon: Icons.savings_outlined,
          title: 'Épargne & crédit',
          subtitle: 'Suivi des demandes et remboursements',
          state: 'À configurer',
        ),
        const _SystemModuleRow(
          icon: Icons.security_outlined,
          title: 'Sécurité & audit',
          subtitle: 'Journalisation et rôles administrateur',
          state: 'Démo locale',
        ),
      ],
    );
  }

  Widget _buildClients(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '${widget.clients.length} client${widget.clients.length == 1 ? '' : 's'} inscrit${widget.clients.length == 1 ? '' : 's'}',
          style: TextStyle(
            color: context.appText,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (widget.clients.isEmpty)
          const _AdminEmptyState(message: 'Aucun client inscrit.')
        else
          ...widget.clients.map(_ClientAdminCard.new),
      ],
    );
  }

  Widget _buildOperations(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Journal des opérations',
                style: TextStyle(
                  color: context.appText,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${transactions.length} entrée${transactions.length == 1 ? '' : 's'}',
              style: TextStyle(color: context.appMuted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          const _AdminEmptyState(
            message: 'Aucune opération enregistrée dans cette session.',
          )
        else
          ...transactions.map(
            (transaction) => _AdminTransactionCard(
              transaction: transaction,
              client: _clientFor(transaction.userId),
            ),
          ),
      ],
    );
  }

  User? _clientFor(String id) {
    for (final client in widget.clients) {
      if (client.id == id) return client;
    }
    return null;
  }

  Future<void> _changeRate() async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => _ExchangeRateDialog(
        currentRate: widget.wallet.usdToCdfRate,
        onSave: widget.wallet.updateExchangeRate,
      ),
    );
    if (changed == true && mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Taux de change mis à jour.')),
      );
    }
  }
}

class _ExchangeRateDialog extends StatefulWidget {
  const _ExchangeRateDialog({required this.currentRate, required this.onSave});

  final double currentRate;
  final ValueChanged<double> onSave;

  @override
  State<_ExchangeRateDialog> createState() => _ExchangeRateDialogState();
}

class _ExchangeRateDialogState extends State<_ExchangeRateDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentRate.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Taux USD / CDF'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'CDF pour 1 USD',
            errorText: _error,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Cette modification est immédiate dans le portefeuille de démonstration.',
          style: TextStyle(color: context.appMuted, fontSize: 11),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Annuler'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Enregistrer')),
    ],
  );

  void _submit() {
    final value = double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    if (value == null || !value.isFinite || value <= 0) {
      setState(() => _error = 'Saisissez un taux positif.');
      return;
    }
    widget.onSave(value);
    Navigator.pop(context, true);
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - 51) / 2,
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.appText,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.appMuted, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

class _SystemModuleRow extends StatelessWidget {
  const _SystemModuleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String state;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.appCard,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon, color: context.appAccent, size: 21),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.appText,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(color: context.appMuted, fontSize: 10),
              ),
            ],
          ),
        ),
        Text(
          state,
          style: TextStyle(
            color: context.appAccent,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _ClientAdminCard extends StatelessWidget {
  const _ClientAdminCard(this.client);

  final User client;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: context.appCard,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: context.appAccentSoft,
          backgroundImage: client.profilePhotoBytes == null
              ? null
              : MemoryImage(client.profilePhotoBytes!),
          child: client.profilePhotoBytes == null
              ? Text(
                  client.firstName.isEmpty
                      ? '?'
                      : client.firstName[0].toUpperCase(),
                  style: TextStyle(
                    color: context.appAccent,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.fullName,
                style: TextStyle(
                  color: context.appText,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                client.email,
                style: TextStyle(color: context.appMuted, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                'N° ${client.identityNumber} • Mandataire: ${client.mandataire.fullName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.appMuted, fontSize: 10),
              ),
            ],
          ),
        ),
        Icon(Icons.verified_user_outlined, color: context.appAccent, size: 19),
      ],
    ),
  );
}

class _AdminTransactionCard extends StatelessWidget {
  const _AdminTransactionCard({
    required this.transaction,
    required this.client,
  });

  final Transaction transaction;
  final User? client;

  @override
  Widget build(BuildContext context) {
    final title = switch (transaction.type) {
      TransactionType.deposit => 'Dépôt',
      TransactionType.withdrawal => 'Retrait',
      TransactionType.transferIn => 'Virement reçu',
      TransactionType.transferOut => 'Virement envoyé',
      TransactionType.savingsInvestment => 'Placement épargne',
      TransactionType.loanDisbursement => 'Décaissement crédit',
      TransactionType.loanRepayment => 'Remboursement crédit',
    };
    final outgoing =
        transaction.type == TransactionType.withdrawal ||
        transaction.type == TransactionType.transferOut ||
        transaction.type == TransactionType.savingsInvestment ||
        transaction.type == TransactionType.loanRepayment;
    final date = transaction.createdAt;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.appText,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${outgoing ? '-' : '+'}${transaction.currency.format(transaction.amount)}',
                style: TextStyle(
                  color: outgoing
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${client?.fullName ?? transaction.userId} • ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
            style: TextStyle(color: context.appMuted, fontSize: 10),
          ),
          if (transaction.fee > 0) ...[
            const SizedBox(height: 5),
            Text(
              'Frais prélevés : ${transaction.currency.format(transaction.fee)}',
              style: TextStyle(color: context.appMuted, fontSize: 10),
            ),
          ],
          if (transaction.counterparty != null) ...[
            const SizedBox(height: 5),
            Text(
              'Compte associé : ${transaction.counterparty}',
              style: TextStyle(color: context.appMuted, fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }
}

class _AdminEmptyState extends StatelessWidget {
  const _AdminEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: context.appCard,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: context.appMuted, fontSize: 12),
    ),
  );
}
