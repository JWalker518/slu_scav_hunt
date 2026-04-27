import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance.
/// This should be overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Provider to handle theme mode persistence.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      return ThemeMode.values[themeIndex];
    }
    return ThemeMode.system;
  }

  Future<void> toggleTheme() async {
    final prefs = ref.read(sharedPreferencesProvider);
    
    final ThemeMode nextMode;
    if (state == ThemeMode.light) {
      nextMode = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      nextMode = ThemeMode.light;
    } else {
      // If currently system mode, we need to toggle to the OPPOSITE of system brightness
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.light) {
        nextMode = ThemeMode.dark;
      } else {
        nextMode = ThemeMode.light;
      }
    }
    
    state = nextMode;
    await prefs.setInt(_themeKey, state.index);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = mode;
    await prefs.setInt(_themeKey, state.index);
  }
}
