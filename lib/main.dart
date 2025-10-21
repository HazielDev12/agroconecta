import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:agroconecta/config/theme/router/app_router.dart';
import 'package:flutter/material.dart';

/*Pagina de menú principal de usuarios */

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false, //Remove banner debug tag
      theme: AppTheme(selectedColor: 0).getTheme(),
    );
  }
}
