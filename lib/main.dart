import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:agroconecta/config/router/app_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

void main() {
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

      // 👇 Parche global para el botón físico/gesto “Atrás”
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            final r = GoRouter.of(context);

            // 1) Si hay historial, hacemos pop
            if (r.canPop()) {
              r.pop();
              return false;
            }

            // 2) Si no hay historial y NO estamos en /home, vamos a /home
            final loc = r.routeInformationProvider.value.location;
            if (loc != '/home') {
              r.go('/home');
              return false;
            }

            // 3) Ya estamos en /home -> permitir salir de la app
            return true;
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
