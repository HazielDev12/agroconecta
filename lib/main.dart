import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';

import 'package:agroconecta/config/router/app_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa datos de fecha para español (México)
  await initializeDateFormatting('es_MX', null);
  Intl.defaultLocale = 'es_MX';

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),

      // Localización
      supportedLocales: const [
        Locale('es', 'MX'),
        Locale('es'),
        Locale('en'),
      ],
      locale: const Locale('es', 'MX'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Parche global para el botón/gesto “Atrás”
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            final r = GoRouter.of(context);
            if (r.canPop()) {
              r.pop();
              return false;
            }
            final loc = r.routeInformationProvider.value.location;
            if (loc != '/home') {
              r.go('/home');
              return false;
            }
            return true;
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
