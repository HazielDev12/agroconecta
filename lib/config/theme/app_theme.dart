import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorList = <Color>[
  Color(0xFF22A788),
  Color(0xFFFF9933),
  Color(0xFFFFFFFF),
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
    : assert(selectedColor >= 0, 'El color debe ser mayor o igual a 0'),
      assert(
        selectedColor < colorList.length,
        'El color seleccionado debe ser menor o igual al ${colorList.length - 1}',
      );

  ThemeData getTheme() => ThemeData(
    //General
    useMaterial3: true,
    colorSchemeSeed: colorList[selectedColor],

    //Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.montserratAlternates().copyWith(fontSize: 20),
    ),

    //Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.montserrat().copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
