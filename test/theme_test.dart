import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slu_scav_hunt/theme.dart';

void main() {
  group('AppTheme Tests', () {
    test('lightTheme should use primaryColor', () {
      final theme = AppTheme.lightTheme;
      expect(theme.colorScheme.primary, AppTheme.primaryColor);
      expect(theme.brightness, Brightness.light);
    });

    test('darkTheme should use primaryColorDark for better visibility', () {
      final theme = AppTheme.darkTheme;
      // Note: ColorScheme.fromSeed might slightly adjust the color, 
      // but 'primary' should be close or equal if explicitly set.
      expect(theme.colorScheme.primary, AppTheme.primaryColorDark);
      expect(theme.brightness, Brightness.dark);
    });

    test('darkTheme elevatedButtonTheme should have correct contrast', () {
      final theme = AppTheme.darkTheme;
      final buttonStyle = theme.elevatedButtonTheme.style;
      
      final bgColor = buttonStyle?.backgroundColor?.resolve({});
      final fgColor = buttonStyle?.foregroundColor?.resolve({});

      expect(bgColor, AppTheme.primaryColorDark);
      expect(fgColor, Colors.black);
    });

    test('lightTheme tabBarTheme should have correct colors', () {
      final theme = AppTheme.lightTheme;
      expect(theme.tabBarTheme.labelColor, Colors.white);
      expect(theme.tabBarTheme.unselectedLabelColor, Colors.white70);
      expect(theme.tabBarTheme.indicatorColor, AppTheme.accentColor);
    });

    test('darkTheme tabBarTheme should have correct colors', () {
      final theme = AppTheme.darkTheme;
      expect(theme.tabBarTheme.labelColor, AppTheme.primaryColorDark);
      expect(theme.tabBarTheme.indicatorColor, AppTheme.primaryColorDark);
    });
  });
}
