import 'package:flutter/material.dart';

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

  ThemeData getTheme() =>
      ThemeData(useMaterial3: true, colorSchemeSeed: colorList[selectedColor]);
}
