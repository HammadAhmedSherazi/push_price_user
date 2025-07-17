

import '../export_all.dart';

extension Spacing on num {
  SizedBox get ph => SizedBox(height: toDouble().h);

  SizedBox get pw => SizedBox(width: toDouble().w);
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textStyle => theme.textTheme;

  InputDecorationTheme get inputTheme => theme.inputDecorationTheme;

  BottomNavigationBarThemeData get bottomAppStyle =>
      theme.bottomNavigationBarTheme;

  double get screenwidth => MediaQuery.of(this).size.width;
  double get screenheight => MediaQuery.of(this).size.height;
}