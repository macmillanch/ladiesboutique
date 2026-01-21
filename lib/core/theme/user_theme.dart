import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class UserTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryUser,
      scaffoldBackgroundColor: AppColors.backgroundUser,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryUser, // Plum
        secondary: AppColors.secondaryUser, // Sage
        surface: AppColors.backgroundUser,
        onSurface: AppColors.textUser,
      ),
      textTheme: GoogleFonts.manropeTextTheme().copyWith(
        displayLarge: GoogleFonts.epilogue(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textUser,
        ),
        displayMedium: GoogleFonts.epilogue(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textUser,
        ),
        headlineLarge: GoogleFonts.epilogue(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textUser,
        ),
        headlineMedium: GoogleFonts.epilogue(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textUser,
        ),
        titleLarge: GoogleFonts.epilogue(
          // For AppBars probably
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryUser, // Make brand name primary color
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textUser),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textUser),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundUser.withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textUser),
        titleTextStyle: GoogleFonts.epilogue(
          color: AppColors.primaryUser,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryUser,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryUser),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardColor,
        selectedItemColor: AppColors.primaryUser,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),
    );
  }
}
