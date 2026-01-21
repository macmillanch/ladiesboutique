import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AdminTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryAdmin,
      scaffoldBackgroundColor: AppColors.backgroundAdmin,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryAdmin,
        secondary: AppColors.secondaryAdmin,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.roboto(
          fontSize: 20,
          color: AppColors.textAdmin,
        ), // Extra large
        bodyMedium: GoogleFonts.roboto(
          fontSize: 18,
          color: AppColors.textAdmin,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textAdmin,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryAdmin,
        elevation: 2,
        titleTextStyle: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAdmin,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ), // Big buttons
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryAdmin,
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
