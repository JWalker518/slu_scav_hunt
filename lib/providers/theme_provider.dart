import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider to handle theme mode persistence.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;

  @override
  ThemeMode build() {
    // We can't use async in build, so we'll load the initial value
    // synchronously or use a default. For Riverpod, the recommended
    // pattern for SharedPreferences is to initialize it before runApp.
    // However, for a simple toggle, we can initialize it here.
    _init();
    return ThemeMode.system;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final themeIndex = _prefs.getInt(_themeKey);
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    }
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
    await _prefs.setInt(_themeKey, state.index);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setInt(_themeKey, state.index);
  }
}
