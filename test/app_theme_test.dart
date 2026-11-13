import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:african/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('theme notifier toggles between light and dark modes', () {
    final notifier = ThemeNotifier();
    addTearDown(notifier.dispose);

    expect(notifier.themeMode, ThemeMode.system);
    notifier.toggle();
    expect(notifier.themeMode, ThemeMode.dark);
    expect(notifier.isDark, isTrue);
    notifier.toggle();
    expect(notifier.themeMode, ThemeMode.light);
    expect(notifier.isDark, isFalse);
  });

  test('light and dark themes expose the intended brightness', () {
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.brightness, Brightness.dark);
    expect(AppTheme.light.colorScheme.surface, const Color(0xFFF5F7FA));
    expect(AppTheme.dark.colorScheme.surface, const Color(0xFF080D22));
    expect(AppTheme.dark.cardTheme.color, const Color(0xFF111A3A));
    expect(AppTheme.dark.colorScheme.primary, const Color(0xFFE2B84B));
  });
}
