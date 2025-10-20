import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:agroconecta/presentation/screens/menu_principal.dart';
import 'package:flutter/material.dart';

/*Pagina de menú principal de usuarios */


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Remove banner debug tag
      theme: AppTheme(selectedColor: 0).getTheme(),
      home: const HomePage(),
    );
  }
}
