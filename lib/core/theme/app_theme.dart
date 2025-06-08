import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Tajawal",
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF16CA8B), // Custom primary color
      onPrimary: Color(0xFFFFFFFF), // Text/icons on primary
      secondary: Color(0xFF698596), // Secondary color
      onSecondary: Color(0xFF000000),
      primaryContainer: Colors.white,
      surface: Color(0xFFFBFAFF), // For cards, sheets, etc.
      onSurface: Color(0xFF000000),
      error: Color(0xFFD54444), // Error color
      onError: Color(0xFFFFFFFF),
      outline: Color(0xFFEAEEF0), // Outline color
      onSurfaceVariant: Color(0xFF49454F),
      surfaceContainerLow: Color(0xFFEAEEF0),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Tajawal",
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF16CA8B), // Custom primary color
      onPrimary: Color(0xFFFFFFFF), // Text/icons on primary
      secondary: Color(0xFF698596), // Secondary color
      onSecondary: Color(0xFF000000),
      primaryContainer: Colors.white,
      surface: Color(0xFFFBFAFF), // For cards, sheets, etc.
      onSurface: Color(0xFF000000),
      error: Color(0xFFD54444), // Error color
      onError: Color(0xFFFFFFFF),
      outline: Color(0xFFEAEEF0), // Outline color
      onSurfaceVariant: Color(0xFF49454F),
      surfaceContainerLow: Color(0xFFEAEEF0),
    ),
  );
}
