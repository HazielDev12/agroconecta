import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  final Object? error;
  final String? location; // ubicación que falló (opcional)

  const NotFoundScreen({
    super.key,
    this.error,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Future<bool> _handleSystemBack() async {
      final router = GoRouter.of(context);

      // 1) Si hay historial, hacemos pop y bloqueamos el pop del sistema
      if (router.canPop()) {
        router.pop();
        return false;
      }

      // 2) Si no hay historial y no estamos en /home, vamos a /home
      final loc = location ?? router.routeInformationProvider.value.location;
      if (loc != '/home') {
        router.go('/home');
        return false;
      }

      // 3) Ya estamos en /home -> permitir salir de la app
      return true;
    }

    void _backOrHome() {
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
      } else {
        router.go('/home');
      }
    }

    return WillPopScope(
      onWillPop: _handleSystemBack,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: const Text('Página no encontrada'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _backOrHome,
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
                  error?.toString() ?? 'Ruta inválida o eliminada.',
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
