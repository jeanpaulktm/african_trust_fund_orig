import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/atf_logo.dart';
import '../domain/models/payment_result.dart';
import '../domain/services/payment_gateway.dart';

class CounterWithdrawalScannerPage extends StatefulWidget {
  const CounterWithdrawalScannerPage({super.key, required this.paymentGateway});

  final PaymentGateway paymentGateway;

  @override
  State<CounterWithdrawalScannerPage> createState() =>
      _CounterWithdrawalScannerPageState();
}

class _CounterWithdrawalScannerPageState
    extends State<CounterWithdrawalScannerPage> {
  bool _processing = false;
  String? _message;
  bool? _confirmed;
  String? _lastScannedValue;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    if (capture.barcodes.isEmpty) return;
    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue == _lastScannedValue) return;
    _lastScannedValue = rawValue;
    final ticketId = parseCounterWithdrawalQr(rawValue);
    if (ticketId == null) {
      setState(() {
        _message = 'QR code invalide. Scannez un bordereau African Trust Fund.';
        _confirmed = false;
      });
      return;
    }

    setState(() {
      _processing = true;
      _message = 'Vérification du bordereau auprès du serveur…';
      _confirmed = null;
    });
    try {
      final result = await widget.paymentGateway.confirmCounterWithdrawal(
        ticketId: ticketId,
      );
      if (!mounted) return;
      setState(() {
        _message = result.reference == null
            ? result.message
            : '${result.message} Référence : ${result.reference}';
        _confirmed = result.status == PaymentStatus.succeeded;
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _message = 'Échec de vérification : $error';
        _confirmed = false;
      });
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          const AtfLogo(width: 84, height: 38, padding: 3),
          const SizedBox(width: 10),
          Text(
            'Retraits guichet',
            style: TextStyle(
              color: context.appText,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 330,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(onDetect: _onDetect),
                Center(
                  child: Container(
                    width: 235,
                    height: 185,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Text(
                    'Placez le QR code du bordereau dans le cadre',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_message != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _confirmed == true
                    ? context.appAccentSoft
                    : Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_processing)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      _confirmed == true
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded,
                      color: _confirmed == true
                          ? context.appAccent
                          : context.appMuted,
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: context.appText,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Ne remettez les espèces qu’après confirmation réussie par le '
            'serveur. Le code QR seul ne vaut pas autorisation de paiement.',
            style: TextStyle(
              color: context.appMuted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _processing
                ? null
                : () => setState(() {
                    _lastScannedValue = null;
                    _message = null;
                    _confirmed = null;
                  }),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text('Scanner un autre bordereau'),
          ),
        ],
      ),
    ),
  );
}
