import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

// Helpers para pegar cores corretas baseado no tema atual
extension ThemeUtils on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor => isDark
      ? AppTheme.surface
      : AppTheme.surfaceLight;

  Color get bgColor => isDark
      ? AppTheme.background
      : AppTheme.backgroundLight;

  Color get textColor => isDark
      ? AppTheme.white
      : AppTheme.textLight;

  Color get subtitleColor => isDark
      ? AppTheme.grey
      : AppTheme.greyLight;

  Color get dividerColor => isDark
      ? AppTheme.background
      : const Color(0xFFFFE0EE);
}