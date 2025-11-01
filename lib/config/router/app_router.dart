import 'package:agroconecta/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:agroconecta/features/auth/presentation/screens/screens.dart';
import 'package:agroconecta/features/products/presentation/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/* final goRouterProvider = Provider((ref) {
  return;
}); */

/// Configuración de GoRouter (sin navigatorBuilder/builder aquí)
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: '/splash',

  routes: [
    //Primera pantalla
    GoRoute(path: '/splash', builder: (_, _) => const CheckAuthStatusScreen()),

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
    GoRoute(path: '/calendario', builder: (_, _) => const CalendarPage()),
    GoRoute(path: '/parcela', builder: (_, _) => const ParcelaDetailPage()),
    GoRoute(path: '/editar', builder: (_, _) => const ParcelaEditPage()),
    GoRoute(path: '/perfil', builder: (_, _) => const ProfileScreen()),
  ],

  // Página de error personalizada
  errorBuilder: (context, state) =>
      NotFoundScreen(error: state.error, currentLocation: state.uri.toString()),
);
