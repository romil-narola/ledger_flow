import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme([Brightness? currentBrightness]) {
    final isDark = state == ThemeMode.dark ||
        (state == ThemeMode.system && currentBrightness == Brightness.dark);
    emit(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void setThemeMode(ThemeMode mode) {
    if (state != mode) {
      emit(mode);
    }
  }
}
