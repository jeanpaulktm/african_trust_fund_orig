import 'package:flutter/material.dart';

import '../../../core/money/currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/domain/models/user.dart';
import '../domain/models/credit_request.dart';
import '../domain/services/credit_service.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key, required this.user, required this.credit});

  final User user;
  final CreditService credit;

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  Currency _currency = Currency.usd;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final requests = widget.credit.requestsFor(widget.user.id);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Crédit',
          style: TextStyle(
            color: context.appText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Soumettez une demande et suivez son statut.',
          style: TextStyle(color: context.appMuted, fontSize: 13),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appAccentSoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: context.appAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Le décaissement et le remboursement exigent une '
                  'vérification du mot de passe par le service sécurisé.',
                  style: TextStyle(
                    color: context.appText,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        DropdownButtonFormField<Currency>(
          initialValue: _currency,
          decoration: const InputDecoration(labelText: 'Devise souhaitée'),
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
          label: 'Faire une demande',
          icon: Icons.request_quote_outlined,
          onPressed: _busy ? null : _showRequestDialog,
        ),
        const SizedBox(height: 26),
        Text(
          'Mes demandes',
          style: TextStyle(
            color: context.appText,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (requests.isEmpty)
          Text(
            'Aucune demande de crédit pour le moment.',
            style: TextStyle(color: context.appMuted, fontSize: 12),
          )
        else
          ...requests.map(_requestCard),
        const SizedBox(height: 12),
        Text(
          'Prototype local : les demandes ne sont ni évaluées ni transmises à une institution.',
          style: TextStyle(color: context.appMuted, fontSize: 11, height: 1.5),
        ),
      ],
    );
  }

  Widget _requestCard(CreditRequest request) {
    final statusLabel = switch (request.status) {
      CreditRequestStatus.pending => 'En attente',
      CreditRequestStatus.disbursed => 'Décaissé',
      CreditRequestStatus.repaid => 'Remboursé',
    };
    final statusColor = request.status == CreditRequestStatus.pending
        ? Theme.of(context).colorScheme.tertiary
        : context.appAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.currency.format(request.amount),
                  style: TextStyle(
                    color: context.appText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Demande du ${request.createdAt.day.toString().padLeft(2, '0')}/'
            '${request.createdAt.month.toString().padLeft(2, '0')}/'
            '${request.createdAt.year}',
            style: TextStyle(color: context.appMuted, fontSize: 11),
          ),
          if (request.status == CreditRequestStatus.disbursed) ...[
            const SizedBox(height: 5),
            Text(
              'Reste à rembourser : '
              '${request.currency.format(request.outstandingAmount)}',
              style: TextStyle(color: context.appMuted, fontSize: 11),
            ),
          ],
          if (request.status == CreditRequestStatus.pending) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _confirmDisbursement(request),
              icon: const Icon(Icons.lock_outline_rounded),
              label: const Text('Confirmer le décaissement'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.appAccent,
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ],
          if (request.status == CreditRequestStatus.disbursed) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _confirmRepayment(request),
              icon: const Icon(Icons.payments_outlined),
              label: const Text('Rembourser'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.appAccent,
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showRequestDialog() async {
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Demande de crédit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Montant souhaité',
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
            child: const Text('Envoyer la demande'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null || !mounted) return;
    try {
      widget.credit.request(
        userId: widget.user.id,
        currency: _currency,
        amount: amount,
      );
      setState(() {});
    } on ArgumentError catch (error) {
      _showMessage(error.message.toString());
    }
  }

  Future<void> _confirmDisbursement(CreditRequest request) async {
    final controller = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Vérifier votre identité'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmez le décaissement de '
              '${request.currency.format(request.amount)}.',
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe du compte',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Vérifier et décaisser'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (password == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final result = await widget.credit.disburse(
        userId: widget.user.id,
        requestId: request.id,
        password: password,
      );
      if (!mounted) return;
      switch (result) {
        case PasswordVerificationResult.verified:
          setState(() {});
          _showMessage('Décaissement enregistré.');
        case PasswordVerificationResult.rejected:
          _showMessage('Mot de passe incorrect. Aucun fonds n’a été versé.');
        case PasswordVerificationResult.unavailable:
          _showMessage(
            'Vérification indisponible : connectez un service '
            'd’authentification sécurisé.',
          );
      }
    } on StateError catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmRepayment(CreditRequest request) async {
    final amountController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmation = await showDialog<({double amount, String password})>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remboursement du crédit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Montant restant : '
              '${request.currency.format(request.outstandingAmount)}',
            ),
            const SizedBox(height: 14),
            TextField(
              controller: amountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Montant à rembourser',
                suffixText: request.currency.code,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe du compte',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(
                amountController.text.trim().replaceAll(',', '.'),
              );
              if (amount == null ||
                  !amount.isFinite ||
                  amount <= 0 ||
                  passwordController.text.isEmpty) {
                return;
              }
              Navigator.pop(dialogContext, (
                amount: amount,
                password: passwordController.text,
              ));
            },
            child: const Text('Vérifier et rembourser'),
          ),
        ],
      ),
    );
    amountController.dispose();
    passwordController.dispose();
    if (confirmation == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final result = await widget.credit.repay(
        userId: widget.user.id,
        requestId: request.id,
        amount: confirmation.amount,
        password: confirmation.password,
      );
      if (!mounted) return;
      switch (result) {
        case PasswordVerificationResult.verified:
          setState(() {});
          _showMessage('Remboursement enregistré.');
        case PasswordVerificationResult.rejected:
          _showMessage(
            'Mot de passe incorrect. Aucun remboursement n’a été effectué.',
          );
        case PasswordVerificationResult.unavailable:
          _showMessage(
            'Vérification indisponible : connectez un service '
            'd’authentification sécurisé.',
          );
      }
    } on ArgumentError catch (error) {
      _showMessage(error.message.toString());
    } on StateError catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
