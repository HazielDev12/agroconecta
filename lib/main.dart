import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:agroconecta/config/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';


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

      // habilitar textos/formatos del date picker en español (MX)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'MX'),
        Locale('en', 'US'),
      ],
      // fuerza español MX en toda la app:
      // locale: const Locale('es', 'MX'),
    );
  }
}
