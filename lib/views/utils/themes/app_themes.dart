import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/colors.dart';

class AppTheme {
  static ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bgColor,
      appBarTheme: AppBarTheme(color: primaryColor.withOpacity(0.1)),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: Colors.white),
      canvasColor: secondaryColor);
}