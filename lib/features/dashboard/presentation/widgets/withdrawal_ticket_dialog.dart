import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../payments/domain/models/withdrawal_ticket.dart';

class WithdrawalTicketDialog extends StatelessWidget {
  const WithdrawalTicketDialog({super.key, required this.ticket});

  final WithdrawalTicket ticket;

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
    title: const Text('Bordereau de retrait'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Présentez ce QR code au guichetier. Le retrait ne sera confirmé '
            'qu’après validation par son compte professionnel.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: ticket.qrPayload,
              version: QrVersions.auto,
              size: 210,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _TicketRow(label: 'Référence', value: ticket.reference),
          _TicketRow(
            label: 'Montant à recevoir',
            value: ticket.currency.format(ticket.amount),
          ),
          _TicketRow(
            label: 'Frais (1 %)',
            value: ticket.currency.format(ticket.fee),
          ),
          _TicketRow(
            label: 'Total à débiter',
            value: ticket.currency.format(ticket.totalDebit),
            emphasized: true,
          ),
          const SizedBox(height: 10),
          Text(
            'Expire le ${ticket.expiresAt.day.toString().padLeft(2, '0')}/'
            '${ticket.expiresAt.month.toString().padLeft(2, '0')}/'
            '${ticket.expiresAt.year} à '
            '${ticket.expiresAt.hour.toString().padLeft(2, '0')}:'
            '${ticket.expiresAt.minute.toString().padLeft(2, '0')}',
            style: TextStyle(color: context.appMuted, fontSize: 11),
          ),
        ],
      ),
    ),
    actions: [
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Terminer'),
      ),
    ],
  );
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: context.appMuted, fontSize: 12),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasized ? context.appAccent : context.appText,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
