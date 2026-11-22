import 'package:flutter/material.dart';
import 'lunora_schemes.dart';

class LunoraTheme {
  LunoraTheme._();

  static ThemeData build({
    required LunoraScheme scheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: scheme.primary,
      brightness: brightness,
    ).copyWith(
      primary: scheme.primary,
      onPrimary: isDark ? Colors.black : Colors.white,
      secondary: scheme.primaryDeep,
      surface: scheme.surfaceAlt,
      onSurface: scheme.ink,
      error: const Color(0xFFE0A458),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.ink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: scheme.ink,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.15,
        ),
        headlineLarge: TextStyle(
          color: scheme.ink,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          color: scheme.ink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleLarge: TextStyle(
          color: scheme.ink,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          color: scheme.ink,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: scheme.ink,
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: scheme.inkSoft,
          fontSize: 14,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          color: scheme.ink,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceAlt,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: scheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: scheme.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: scheme.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: scheme.primary,
            width: 1.5,
          ),
        ),
        hintStyle: TextStyle(color: scheme.inkPale),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.line,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
