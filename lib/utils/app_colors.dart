import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors{
  
  static Color primaryColor=const Color(0xFF4C7E95);
  static Color backgroundColor=const Color(0xFFFFFFFF);
  static Color cardColor = const Color(0xFF2F2F2F);
  static Color cardLightColor = const Color(0xFF555555);
  static Color buttonColor = const Color(0xFF85594B);
  static Color borderColor = const Color(0xFF4C7E95);
  static Color textColor = const Color(0xFFFFFFFF);
  static Color white = const Color(0xFFFFFFFF);
  static Color subTextColor = const Color(0xFFE8E8E8);
  static Color hintColor = const Color(0xFFB5B5B5);
  static Color greyColor = const Color(0xFFB5B5B5);
  static Color fillColor = const Color(0xFFedf2f4);
  static Color dividerColor = const Color(0xFF555555);
  static Color shadowColor = const Color(0xFF2B2A2A);
  static Color bottomBarColor = const Color(0xFF343434);
  static Color redColor = const Color(0xFFFF6161);
  static Color notificationBGcolor = const Color(0xFFF4F4F4);

  static BoxShadow shadow=BoxShadow(
    blurRadius: 4,
    spreadRadius: 0,
    color: shadowColor,
    offset: const Offset(0, 2),
  );
}