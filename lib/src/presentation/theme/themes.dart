import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

extension WThemes on Never {
  static final pink = FThemeData(
    debugLabel: 'Pink ThemeData',
    colors: const FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      barrier: Color(0x33000000),
      background: Color(0xFFFCEEF3),
      foreground: Color(0xFF230610),
      primary: Color(0xFF9A5B7F),
      primaryForeground: Color(0xFFFFF1F2),
      secondary: Color(0xFFF0E5EB),
      secondaryForeground: Color(0xFF18181B),
      muted: Color(0xFFF4F4F5),
      mutedForeground: Color(0xFFA88994),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
      errorForeground: Color(0xFFFAFAFA),
      border: Color(0xFFE1CCD8),
    ),
  );
}
