import 'package:flutter/material.dart';

extension BuildContextThemeExtensions on BuildContext {
  TextTheme get appTextTheme => Theme.of(this).textTheme;
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}
