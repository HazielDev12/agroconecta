import 'package:agroconecta/presentation/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: '/login',
  routes: [
    // Evita "no routes for location: /"
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),

    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/home', builder:  (_, __) => const HomePage()),
    GoRoute(path: '/convocatorias', builder: (_, __) => const ConvocatoriaPage()),
  ],

  // Página de error personalizada
  errorBuilder: (context, state) =>
      NotFoundScreen(error: state.error, currentLocation: state.uri.toString()),
);

class NotFoundScreen extends StatelessWidget {
  final Exception? error;
  final String? currentLocation; // 👈 la ubicación actual viene del errorBuilder
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
        final loc = currentLocation ?? // preferimos la pasada por errorBuilder
            router.routeInformationProvider.value.location; // fallback compatible
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
              final router = GoRouter.of(context);
              if (router.canPop()) {
                router.pop();
              } else {
                router.go('/home');
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
                Icon(Icons.explore_off,
                    size: 64, color: cs.onSurface.withValues(alpha: .6)),
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
