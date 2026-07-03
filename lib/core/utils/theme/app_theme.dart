import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/app_color.dart';

class AppTheme {
  // Clamps font sizes so sp doesn't explode on tablets portrait
  // or shrink too much on tablets landscape.
  static double _fs(double base, double min, double max) =>
      base.sp.clamp(min, max).toDouble();

  static TextTheme _buildTextTheme() {
    return TextTheme(
      // heading — 30sp, clamped 24–34
      displayLarge: TextStyle(
        fontSize: _fs(30, 24, 34),
        fontWeight: FontWeight.bold,
      ),
      // title — 22sp, clamped 18–26
      titleLarge: TextStyle(
        fontSize: _fs(22, 18, 26),
        fontWeight: FontWeight.w700,
      ),
      // subtitle — 18sp, clamped 15–21
      titleMedium: TextStyle(
        fontSize: _fs(18, 15, 21),
        fontWeight: FontWeight.w600,
      ),
      // body — 16sp, clamped 13–18
      bodyLarge: TextStyle(
        fontSize: _fs(16, 13, 18),
        fontWeight: FontWeight.normal,
      ),
      // caption — 12sp, clamped 11–14
      bodySmall: TextStyle(
        fontSize: _fs(12, 11, 14),
        fontWeight: FontWeight.w400,
      ),
      // button — 15sp, clamped 13–17
      labelLarge: TextStyle(
        fontSize: _fs(15, 13, 17),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        textTheme: _buildTextTheme(),
        iconTheme: const IconThemeData(color: AppColors.primary, size: 24),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: _fs(20, 16, 22),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        textTheme: _buildTextTheme(),
        iconTheme: const IconThemeData(color: AppColors.primary, size: 24),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
          actionsIconTheme:
              const IconThemeData(color: AppColors.primary),
          titleTextStyle: TextStyle(
            fontSize: _fs(20, 16, 22),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      );
}
