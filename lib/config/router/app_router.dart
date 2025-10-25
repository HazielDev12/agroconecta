import 'package:agroconecta/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/convocatorias', builder: (context, state) => ConvocatoriaPage()),
  ],

    // Página de error personalizada
  errorBuilder: (context, state) => NotFoundScreen(error: state.error),

);

class NotFoundScreen extends StatelessWidget {
  final Exception? error;
  const NotFoundScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        context.goNamed('home'); // botón físico back → Home
        return false;
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: const Text('Página no encontrada'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goNamed('home'), // flecha → Home
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
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: .7),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go('/home'),
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
