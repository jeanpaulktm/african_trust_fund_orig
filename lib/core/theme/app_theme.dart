import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const _emerald = Color(0xFF087A52);
  static const _darkNavy = Color(0xFF080D22);
  static const _navy = Color(0xFF111A3A);
  static const _gold = Color(0xFFE2B84B);

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: _emerald,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD8F3E4),
      onPrimaryContainer: Color(0xFF073F2B),
      secondary: Color(0xFF39745A),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFD9EEE2),
      onSecondaryContainer: Color(0xFF143D2A),
      tertiary: Color(0xFF876B26),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFF4E8C8),
      onTertiaryContainer: Color(0xFF382B0A),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFF5F7FA),
      onSurface: Color(0xFF17231C),
      onSurfaceVariant: Color(0xFF5E6D63),
      outline: Color(0xFFCFD9D2),
      outlineVariant: Color(0xFFE2E9E4),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF29352E),
      onInverseSurface: Color(0xFFF0F4F1),
      inversePrimary: Color(0xFF7DDBA9),
      surfaceTint: _emerald,
    );
    return _build(scheme);
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _gold,
      onPrimary: _darkNavy,
      primaryContainer: Color(0xFF3C3424),
      onPrimaryContainer: Color(0xFFFFE6A3),
      secondary: Color(0xFFB8C7F5),
      onSecondary: Color(0xFF202B50),
      secondaryContainer: Color(0xFF29365F),
      onSecondaryContainer: Color(0xFFDCE3FF),
      tertiary: Color(0xFFFFD98A),
      onTertiary: Color(0xFF3C2E0A),
      tertiaryContainer: Color(0xFF57451B),
      onTertiaryContainer: Color(0xFFFFE8B2),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: _darkNavy,
      onSurface: Color(0xFFF7F8FC),
      onSurfaceVariant: Color(0xFFC1C8DA),
      outline: Color(0xFF59627C),
      outlineVariant: Color(0xFF343E5C),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFE8EBF5),
      onInverseSurface: Color(0xFF20243A),
      inversePrimary: _gold,
      surfaceTint: _gold,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: isDark ? _navy : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0 : 1,
        shadowColor: const Color(0x160D3825),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _navy : Colors.white,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF0D1430) : Colors.white,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF202B50)
            : const Color(0xFF20352A),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
      textTheme: ThemeData(brightness: scheme.brightness).textTheme
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => switch (_themeMode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark,
  };

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggle() {
    setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}

extension AppThemeContext on BuildContext {
  Color get appSurface => Theme.of(this).colorScheme.surface;

  Color get appCard => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF111A3A)
      : Colors.white;

  Color get appSubtle => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF1A2447)
      : const Color(0xFFEEF4F0);

  Color get appAccentSoft => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF3C3424)
      : const Color(0xFFE2F3E9);

  Color get appText => Theme.of(this).colorScheme.onSurface;

  Color get appMuted => Theme.of(this).colorScheme.onSurfaceVariant;

  Color get appAccent => Theme.of(this).colorScheme.primary;

  Color get appBorder => Theme.of(this).colorScheme.outlineVariant;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
