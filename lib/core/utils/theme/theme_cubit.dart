import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helper/cach_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    getSavedTheme();
  }

  static const String _themeKey = "isDarkMode";

  void toggleTheme() {
    final bool isDark = state == ThemeMode.dark;
    setTheme(!isDark);
  }

  void setTheme(bool isDark) {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    CacheHelper.saveData(key: _themeKey, value: isDark);
  }

  void getSavedTheme() {
    final bool? isDark = CacheHelper.getData(key: _themeKey);
    if (isDark == null) {
      emit(ThemeMode.system);
    } else {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }
}