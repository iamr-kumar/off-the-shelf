// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Pallete {
  // Colors
  static const Color primaryBlue = Color(0xFF0164FE);
  static const Color primaryBlueOpaque = Color(0xFF3280FE);
  static const Color textBlue = Color(0xFF0A093D);
  static const Color greyOne = Color(0xFFF1F6F7);
  static const Color textGrey = Color(0xFF959595);
  static const Color textGreyLight = Color(0xFFEAEAEA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blueGrey = Color(0xFFF4F7F9);
  static const Color red = Color(0xFFFE3644);

  static const Color blackColor = Color(0xFF010100);
  static const Color secondaryBlack = Color(0xFF191919);
  static const Color textGreyDark = Color(0xFFE8E8E8);

  // // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: secondaryBlack,
    appBarTheme: const AppBarTheme(
      backgroundColor: blackColor,
      iconTheme: IconThemeData(
        color: white,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: blackColor,
    ),
    primaryColor: primaryBlue,
    // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: white,
    cardColor: white,
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: primaryBlue,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: white,
    ),
    primaryColor: primaryBlue,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _themeMode;

  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _themeMode = mode,
        super(Pallete.lightModeAppTheme) {
    getTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
    } else {
      _themeMode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      prefs.setString('theme', 'light');
    } else {
      _themeMode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
