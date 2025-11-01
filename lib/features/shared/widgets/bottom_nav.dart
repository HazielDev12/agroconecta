import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Barra de navegación inferior reutilizable.
/// - Detecta automáticamente la pestaña activa a partir de la URL.
/// - Navega con `context.go()` para evitar apilar rutas.
/// - Úsala como `bottomNavigationBar: const BottomNavBarAgro()`.
class BottomNavBarAgro extends StatelessWidget {
  const BottomNavBarAgro({super.key});

  static const _tabs = <String>['/home', '/apoyos', '/evidencias', '/perfil'];

  /// Mapea la ubicación actual a índice.
  int _indexForLocation(String loc) {
    if (loc.startsWith('/apoyos')) return 1;
    if (loc.startsWith('/evidencias')) return 2;
    if (loc.startsWith('/perfil')) return 3;
    return 0; // default: home
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final selected = _indexForLocation(loc);
    final cs = Theme.of(context).colorScheme;

    return NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: cs.primary.withValues(alpha: 0.15),
      surfaceTintColor: Colors.transparent,
      selectedIndex: selected,
      onDestinationSelected: (i) {
        if (i == selected) return; // evita navegar si ya estás en esa pestaña
        context.go(_tabs[i]);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.volunteer_activism_outlined),
          selectedIcon: Icon(Icons.volunteer_activism),
          label: 'Apoyos',
        ),
        NavigationDestination(
          icon: Icon(Icons.photo_library_outlined),
          selectedIcon: Icon(Icons.photo_library),
          label: 'Evidencias',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Yo',
        ),
      ],
    );
  }
}
