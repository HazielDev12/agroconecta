import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:agroconecta/config/router/app_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:agroconecta/core/notifications/notification_service.dart';
import 'package:agroconecta/features/products/presentation/screens/alerta_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Clave para navegar al tocar notificaciones
  NotificationService.I.navigatorKey = GlobalKey<NavigatorState>();

  // Inicializa permisos, canales y listeners
  await NotificationService.I.initialize();

  // Programa notificaciones con base en tus eventos (hoy..+7 días)
  await NotificationService.I.scheduleUpcomingWeek(days: 7);

  // (Opcional, solo DEBUG) Pruebas: una inmediata y otra en 1 minuto
  assert(() {
    Future(() async {
      await Future.delayed(const Duration(seconds: 3));
      await NotificationService.I.showInstantTest();
      await _devScheduleIn1Minute(); // agenda una para +1 min
    });
    return true;
  }());

  runApp(const ProviderScope(child: MainApp()));
}

// ---------- Utilidad de prueba (solo se ejecuta en DEBUG por el assert) ----------
Future<void> _devScheduleIn1Minute() async {
  final fecha = DateTime.now().add(const Duration(minutes: 1));
  final a = Alerta(
    id: 'dev-1min',
    titulo: 'Recordatorio de prueba (1 min)',
    descripcion: 'Verifica sonido y navegación',
    fecha: fecha,
    route: '/alerta/dev-1min',
  );
  await NotificationService.I.scheduleForAlert(a);
}
// -------------------------------------------------------------------------------

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // Asegúrate que GoRouter use navigatorKey en app_router.dart
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),

      // español (MX) para pickers/formatos
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'MX'), Locale('en', 'US')],

      // Parche global para botón físico/gesto “Atrás”
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
