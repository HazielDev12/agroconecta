import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Clave global que usa NotificationService para navegar desde una notificación
import 'package:agroconecta/core/notifications/notification_service.dart';

// Pantallas
import 'package:agroconecta/features/auth/presentation/screens/screens.dart';
import 'package:agroconecta/features/products/presentation/screens/screens.dart';

// Datos de alertas (para abrir detalle por id)
import 'package:agroconecta/features/products/presentation/screens/alerta_data.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: NotificationService.I.navigatorKey, // <- clave para navegar desde notificaciones
  initialLocation: '/home',

  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/home'),

    // Auth
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/forgot-password', builder: (_, __) => ForgotPasswordScreen()),
    GoRoute(path: '/sign-up', builder: (_, __) => const SignUpScreen()),

    // App
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/convocatorias', builder: (_, __) => const ConvocatoriaPage()),
    GoRoute(path: '/calendario', builder: (_, __) => const CalendarPage()),
    GoRoute(path: '/parcela', builder: (_, __) => const ParcelaDetailPage()),
    GoRoute(path: '/editar', builder: (_, __) => const ParcelaEditPage()),

    // Detalle de alerta (para abrir desde notificación: /alerta/<id>)
    GoRoute(
      path: '/alerta/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        final alerta = findAlerta(id);
        if (alerta == null) {
          return const Scaffold(
            body: Center(child: Text('Alerta no encontrada')),
          );
        }
        return AlertaDetailPage(alerta: alerta);
      },
    ),
  ],

  // Página de error
  errorBuilder: (context, state) =>
      NotFoundScreen(error: state.error, currentLocation: state.uri.toString()),
);

/// Pantalla para rutas no encontradas
class NotFoundScreen extends StatelessWidget {
  final Object? error;
  final String? currentLocation;

  const NotFoundScreen({super.key, this.error, this.currentLocation});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return false;
        }
        final loc = currentLocation ??
            router.routeInformationProvider.value.location;
        if (loc != '/home') {
          router.go('/home');
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: const Text('Página no encontrada'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final r = GoRouter.of(context);
              if (r.canPop()) {
                r.pop();
              } else {
                r.go('/home');
              }
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore_off, size: 64, color: cs.onSurface.withValues(alpha: .6)),
                const SizedBox(height: 12),
                const Text(
                  'Ups… no encontramos esta página',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  (error?.toString() ?? 'Ruta inválida o eliminada.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurface.withValues(alpha: .7)),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => GoRouter.of(context).go('/home'),
                  child: const Text('Ir al inicio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
