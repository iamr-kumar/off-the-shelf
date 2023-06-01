// ignore: file_names
import 'package:flutter/material.dart';

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

  // // Themes
  // static var darkModeAppTheme = ThemeData.dark().copyWith(
  //   scaffoldBackgroundColor: blackColor,
  //   cardColor: greyColor,
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: drawerColor,
  //     iconTheme: IconThemeData(
  //       color: whiteColor,
  //     ),
  //   ),
  //   drawerTheme: const DrawerThemeData(
  //     backgroundColor: drawerColor,
  //   ),
  //   primaryColor: redColor,
  //   backgroundColor:
  //       drawerColor, // will be used as alternative background color
  // );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: greyOne,
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
