import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

ThemeData lightBrownTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFA0522D),
  scaffoldBackgroundColor: const Color(0xffF2ECE6),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    // backgroundColor: Color(0xffF2ECE6), // Light brown app bar
    titleTextStyle: TextStyle(
      color: Colors.brown,
      fontSize: 16.sp,fontWeight: FontWeight.bold
    ),
    iconTheme: IconThemeData(color: Colors.white)
  ),

  // ...other theme properties as needed...
);