import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/widgets/atf_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onCompleted,
    this.duration = const Duration(seconds: 15),
  });

  final VoidCallback onCompleted;
  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotsController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _timer = Timer(widget.duration, widget.onCompleted);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: .18),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const AtfLogo(width: 260, height: 90, padding: 0),
            ),
            const SizedBox(height: 16),
            Text(
              'Votre confiance, notre engagement',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _dotsController,
              builder: (context, _) => SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(8, (index) {
                    final angle = index * math.pi / 4;
                    final phase = (_dotsController.value - index / 8) % 1;
                    final opacity = .25 + .75 * (1 - phase);
                    return Transform.translate(
                      offset: Offset(
                        math.cos(angle) * 21,
                        math.sin(angle) * 21,
                      ),
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
