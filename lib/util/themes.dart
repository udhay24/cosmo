import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color/dark_color.dart';
import 'color/lightColor.dart';

class AppTheme {
  const AppTheme();

  static ThemeData getLightTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      backgroundColor: LightColor.background,
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
          color: Colors.white, textTheme: Theme.of(context).textTheme),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.black,
          contentTextStyle: snackBarStyle,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          behavior: SnackBarBehavior.floating),
      accentColor: LightColor.black,
      primaryColorLight: LightColor.brighter,
      cardTheme: CardTheme(color: LightColor.background),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 4,
          selectedIconTheme: IconThemeData(color: AppColors.PRIMARY_ASCENT),
          unselectedIconTheme: IconThemeData(color: AppColors.SECONDARY_ASCENT),
          selectedLabelStyle: enabledTextStyle,
          unselectedLabelStyle: disabledTextStyle),
      textTheme: TextTheme(
        headline1: h1Style,
        headline2: h2Style,
        headline3: h3Style,
        headline4: h4Style,
        headline5: h5Style,
        headline6: h6Style,
        subtitle1: s1Style,
        subtitle2: s2Style,
      ),
      primaryIconTheme:
          Theme.of(context).iconTheme.copyWith(color: Colors.black),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.lightGrey,
      colorScheme: ColorScheme(
          primary: Colors.black,
          primaryVariant: LightColor.purple,
          secondary: LightColor.lightBlue,
          secondaryVariant: LightColor.darkBlue,
          surface: LightColor.background,
          background: LightColor.background,
          error: Colors.red,
          onPrimary: LightColor.Darker,
          onSecondary: LightColor.background,
          onSurface: LightColor.Darker,
          onBackground: LightColor.titleTextColor,
          onError: LightColor.titleTextColor,
          brightness: Brightness.dark),
    );
  }

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    backgroundColor: LightColor.background,
    primaryColor: LightColor.purple,
    accentColor: LightColor.lightblack,
    primaryColorDark: LightColor.Darker,
    primaryColorLight: LightColor.brighter,
    cardTheme: CardTheme(color: LightColor.background),
    textTheme: TextTheme(display1: TextStyle(color: LightColor.black)),
    iconTheme: IconThemeData(color: LightColor.lightblack),
    bottomAppBarColor: LightColor.background,
    dividerColor: LightColor.lightGrey,
    colorScheme: ColorScheme(
        primary: LightColor.purple,
        primaryVariant: LightColor.purple,
        secondary: LightColor.lightBlue,
        secondaryVariant: LightColor.darkBlue,
        surface: LightColor.background,
        background: LightColor.background,
        error: Colors.red,
        onPrimary: LightColor.Darker,
        onSecondary: LightColor.background,
        onSurface: LightColor.Darker,
        onBackground: LightColor.titleTextColor,
        onError: LightColor.titleTextColor,
        brightness: Brightness.dark),
  );
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    backgroundColor: DarkColor.background,
    primaryColor: DarkColor.purple,
    accentColor: DarkColor.lightblack,
    primaryColorDark: DarkColor.Darker,
    primaryColorLight: DarkColor.brighter,
    cardTheme: CardTheme(color: DarkColor.background),
    textTheme: TextTheme(body1: TextStyle(color: DarkColor.titleTextColor)),
    iconTheme: IconThemeData(color: DarkColor.lightblack),
    bottomAppBarColor: DarkColor.lightblack,
    dividerColor: LightColor.subTitleTextColor,
    colorScheme: ColorScheme(
        primary: DarkColor.purple,
        primaryVariant: DarkColor.purple,
        secondary: DarkColor.lightBlue,
        secondaryVariant: DarkColor.darkBlue,
        surface: DarkColor.background,
        background: DarkColor.background,
        error: Colors.red,
        onPrimary: DarkColor.Brighter,
        onSecondary: DarkColor.Darker,
        onSurface: DarkColor.white,
        onBackground: DarkColor.titleTextColor,
        onError: DarkColor.titleTextColor,
        brightness: Brightness.dark),
  );

  static TextStyle titleStyle =
  const TextStyle(color: LightColor.titleTextColor, fontSize: 16);

  static TextStyle s1Style =
  GoogleFonts.sourceSansPro(
      fontWeight: FontWeight.w400, fontSize: 16, color: LightColor.black);

  static TextStyle s2Style = GoogleFonts.sourceSansPro(
      fontWeight: FontWeight.w300, fontSize: 14, color: LightColor.black);

  static TextStyle h1Style = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: LightColor.black);
  static TextStyle h2Style = GoogleFonts.sourceSansPro(
      fontSize: 22, color: LightColor.black, fontWeight: FontWeight.w400);
  static TextStyle h3Style = GoogleFonts.sourceSansPro(
      fontSize: 20, color: LightColor.black, fontWeight: FontWeight.w600);
  static TextStyle h4Style = GoogleFonts.sourceSansPro(
      fontSize: 18, color: LightColor.black, fontWeight: FontWeight.w600);
  static TextStyle h5Style =
  GoogleFonts.sourceSansPro(fontSize: 16, color: LightColor.black);
  static TextStyle h6Style =
  GoogleFonts.sourceSansPro(fontSize: 14, color: LightColor.black);

  static TextStyle snackBarStyle = GoogleFonts.sourceSansPro(
      fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white);

  static TextStyle disabledTextStyle =
  GoogleFonts.sourceSansPro(fontSize: 14, color: AppColors.SECONDARY_ASCENT);
  static TextStyle enabledTextStyle =
  GoogleFonts.sourceSansPro(fontSize: 14, color: AppColors.PRIMARY_ASCENT);
}

class AppColors {
  static const Color COLOR_WHITE = Colors.white;
  static const Color COLOR_BLACK = Colors.black;
  static const Color PRIMARY_ASCENT = Color(0xFFfca311);
  static const Color SECONDARY_ASCENT = Color(0xFFe5e5e5);
  static const Color COLOR_LIGHT_BLACK = Color(0xFF14213d);

}
