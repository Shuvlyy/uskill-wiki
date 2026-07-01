import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3452FF);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF13100D);
  static const Color inactiveTextColor = Color(0xFF848484);
  static const Color fieldOutlineColor = Color(0xFFCCCCCC);

  static const String titleFont = 'Beatrice';
  static const String bodyFont = 'Source Sans Pro';

  static ThemeData light() {
    final base = ThemeData.light();

    final inputDecorationTheme = const InputDecorationTheme(
      filled: true,
      fillColor: whiteColor,
      hintStyle: TextStyle(color: inactiveTextColor, fontFamily: bodyFont),
      labelStyle: TextStyle(color: blackColor, fontFamily: titleFont),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: fieldOutlineColor, width: 1),
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.zero,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: fieldOutlineColor, width: 1),
        borderRadius: BorderRadius.zero,
      ),
    );

    return base.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: whiteColor,

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: whiteColor,
        secondary: blackColor,
        onSecondary: whiteColor,
        surface: whiteColor,
        onSurface: blackColor,
        outline: fieldOutlineColor,
      ),

      textTheme: _buildTextTheme(base.textTheme),

      popupMenuTheme: PopupMenuThemeData(
        color: whiteColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        mouseCursor: WidgetStateMouseCursor.clickable,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: fieldOutlineColor, width: 1),
        ),
      ),

      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(whiteColor),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          elevation: WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: fieldOutlineColor, width: 1),
            ),
          ),
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputDecorationTheme
      ),

      inputDecorationTheme: inputDecorationTheme,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
        fontWeight: FontWeight.w500
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: titleFont,
        color: blackColor,
      ),

      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: bodyFont,
        color: blackColor,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: bodyFont,
        color: blackColor,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: bodyFont,
        color: blackColor,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: bodyFont,
        color: blackColor,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: bodyFont,
        color: inactiveTextColor,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: bodyFont,
        color: inactiveTextColor,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();

    return base.copyWith(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(primary: primaryColor),
      textTheme: _buildTextTheme(
        base.textTheme,
      ).apply(bodyColor: whiteColor, displayColor: whiteColor),
    );
  }
}
