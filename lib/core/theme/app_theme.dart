// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================================================
  // Colors (Matching Next.js Theme)
  // ============================================================================
  static const Color backgroundColor = Color(0xFF0A0A0F);
  static const Color surfaceColor = Color(0xFF12121A);
  static const Color primaryGold = Color(0xFFE8B04B);
  static const Color primaryGoldHover = Color(0xFFF0BE63);
  static const Color purpleAccent = Color(0xFF8B7FE8);
  static const Color purpleAccentHover = Color(0xFFA599F0);
  static const Color textPrimary = Color(0xFFF2F0EA);
  static const Color textSecondary = Color(0xFF9A96A8);
  static const Color textMuted = Color(0xFF6B6878);
  static const Color textBody = Color(0xFFC9C6D4);
  static const Color borderColor = Color(0xFF2A2A35);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  // ============================================================================
  // Text Styles
  // ============================================================================
  static TextStyle get displayLarge => GoogleFonts.fraunces(
        fontSize: 48.sp,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: -0.02,
        height: 1.05,
      );

  static TextStyle get displayMedium => GoogleFonts.fraunces(
        fontSize: 36.sp,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: -0.02,
        height: 1.05,
      );

  static TextStyle get displaySmall => GoogleFonts.fraunces(
        fontSize: 28.sp,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: -0.02,
        height: 1.1,
      );

  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.01,
        height: 1.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: textBody,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: textBody,
        height: 1.6,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: textSecondary,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: textMuted,
        height: 1.4,
      );

  // ============================================================================
  // Button Styles
  // ============================================================================
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: Size(120.w, 48.h),
      );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: borderColor),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: Size(120.w, 48.h),
      );

  static ButtonStyle get goldOutlineButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGold,
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: primaryGold),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: Size(120.w, 48.h),
      );

  // ============================================================================
  // Theme Data
  // ============================================================================
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: primaryGold,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.dark(
          primary: primaryGold,
          secondary: purpleAccent,
          surface: surfaceColor,
          error: errorColor,
          onPrimary: backgroundColor,
          onSecondary: backgroundColor,
          onSurface: textPrimary,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: TextTheme(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: goldOutlineButtonStyle,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: headlineSmall,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: borderColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: primaryGold),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: errorColor),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          hintStyle: bodySmall.copyWith(color: textMuted),
          labelStyle: bodySmall.copyWith(color: textSecondary),
          floatingLabelStyle: bodySmall.copyWith(color: primaryGold),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: backgroundColor,
          selectedItemColor: primaryGold,
          unselectedItemColor: textMuted,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: backgroundColor,
          indicatorColor: primaryGold.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: borderColor,
          thickness: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceColor,
          contentTextStyle: bodyMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          titleTextStyle: headlineSmall,
          contentTextStyle: bodyMedium,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
          ),
          modalBackgroundColor: surfaceColor,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: bodyMedium,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor),
          ),
          textStyle: bodySmall.copyWith(color: textPrimary),
        ),
      );

  static ThemeData get lightTheme => darkTheme.copyWith(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: primaryGold,
          secondary: purpleAccent,
          surface: surfaceColor,
          error: errorColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: textPrimary,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      );
}