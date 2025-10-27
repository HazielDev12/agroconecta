import 'package:agroconecta/features/auth/presentation/screens/screens.dart';
import 'package:agroconecta/features/products/presentation/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Configuración de GoRouter (sin navigatorBuilder/builder aquí)
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: '/login',

  routes: [
    // Evita "no routes for location: /"
    GoRoute(path: '/', redirect: (_, _) => '/home'),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(path: '/sign-up', builder: (_, _) => const SignUpScreen()),
    GoRoute(path: '/home', builder: (_, _) => const HomePage()),
    GoRoute(
      path: '/convocatorias',
      builder: (_, _) => const ConvocatoriaPage(),
    ),
    GoRoute(
      path: '/calendario',
      builder: (_, _) => const CalendarPage(),
    ),
    GoRoute(
      path: '/parcela',
      builder: (_, _) => const ParcelaDetailPage(),
    ),
    GoRoute(
      path: '/editar',
      builder: (_, _) => const ParcelaEditPage(),
    ),
  ],

  // Página de error personalizada
  errorBuilder: (context, state) =>
      NotFoundScreen(error: state.error, currentLocation: state.uri.toString()),
);

/// Pantalla para rutas no encontradas
class NotFoundScreen extends StatelessWidget {
  final Object? error;
  final String? currentLocation; // llega desde errorBuilder

  const NotFoundScreen({super.key, this.error, this.currentLocation});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        final router = GoRouter.of(context);

        // 1) Si hay historial, hacemos pop
        if (router.canPop()) {
          router.pop();
          return false;
        }

        // 2) Si no hay historial y NO estamos en /home, vamos a /home
        final loc =
            currentLocation ??
            router.routeInformationProvider.value.location; // fallback amplio
        if (loc != '/home') {
          router.go('/home');
          return false;
        }

        // 3) Ya estamos en /home y no hay historial -> salir de la app
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
                Icon(
                  Icons.explore_off,
                  size: 64,
                  color: cs.onSurface.withValues(alpha: .6),
                ),
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
