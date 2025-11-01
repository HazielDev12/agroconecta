import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

        // 1) Si hay historial, pop
        if (router.canPop()) {
          router.pop();
          return false;
        }

        // 2) Si no hay historial y NO estamos en /home, ir a /home
        final loc =
            currentLocation ?? router.routeInformationProvider.value.location;
        if (loc != '/home') {
          router.go('/home');
          return false;
        }

        // 3) Ya en /home y sin historial -> permitir salir
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
