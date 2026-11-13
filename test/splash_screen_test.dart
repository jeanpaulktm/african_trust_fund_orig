import 'package:african/features/auth/presentation/splash_screen.dart';
import 'package:african/core/widgets/atf_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash invokes completion after its configured duration', (
    tester,
  ) async {
    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(
          duration: const Duration(seconds: 2),
          onCompleted: () => completed = true,
        ),
      ),
    );

    expect(find.byType(AtfLogo), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1999));
    expect(completed, isFalse);
    await tester.pump(const Duration(milliseconds: 1));
    expect(completed, isTrue);
  });
}
