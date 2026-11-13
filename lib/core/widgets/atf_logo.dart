import 'package:flutter/material.dart';

class AtfLogo extends StatelessWidget {
  const AtfLogo({
    super.key,
    this.width = 160,
    this.height = 54,
    this.padding = 5,
  });

  final double width;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'African Trust Fund',
    image: true,
    child: Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        'lib/atf.jpg',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Text(
            'ATF',
            style: TextStyle(
              color: Color(0xFF171D55),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    ),
  );
}
