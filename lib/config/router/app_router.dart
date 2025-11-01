import 'package:agroconecta/config/router/app_router_notifier.dart';
import 'package:agroconecta/features/auth/presentation/providers/auth_provider.dart';
import 'package:agroconecta/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:agroconecta/features/auth/presentation/screens/screens.dart';
import 'package:agroconecta/features/products/presentation/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRoutherNotifierProvider);

  return GoRouter(
    // debugLogDiagnostics: kDebugMode,
    initialLocation: '/splash',

    refreshListenable: goRouterNotifier,
    routes: [
      //Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      // Evita "no routes for location: /"
      // GoRoute(path: '/', redirect: (context, context) => '/home'),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/convocatorias',
        builder: (context, state) => const ConvocatoriaPage(),
      ),
      GoRoute(
        path: '/calendario',
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: '/parcela',
        builder: (context, state) => const ParcelaDetailPage(),
      ),
      GoRoute(
        path: '/editar',
        builder: (context, state) => const ParcelaEditPage(),
      ),
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],

    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        }
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/home';
        }
      }

      return null;
    },

    // Página de error personalizada
    errorBuilder: (context, state) => NotFoundScreen(
      error: state.error,
      currentLocation: state.uri.toString(),
    ),
  );
});
