import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.accents.last),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'], // Fallback fonts
          fontSize: 36.sp, // Reduced slightly for better adaptability
          fontWeight: FontWeight.w600, // Slightly bolder for emphasis
          height: 1.2, // Improved readability
          letterSpacing: -0.5, // Slightly tighter for larger text
          color: Colors.black, // Default color, can be overridden
        ),
        displayMedium: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 28.sp,
          fontWeight: FontWeight.w500,
          height: 1.3,
          letterSpacing: -0.3,
          color: Colors.black87,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: -0.2,
          color: Colors.black87,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 30.sp,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.4,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: Colors.black87,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: Colors.black87,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 1.5, // Better spacing for body text
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Colors.black54,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 12.sp,
          fontWeight: FontWeight.w600, // Bold for labels
          height: 1.2,
          letterSpacing: 0.2, // Slightly looser for emphasis
          color: Colors.black,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: Colors.black87,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Satoshi',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 8.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: Colors.black54,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepOrange,
      useMaterial3: true,
    );
  }
}
