import 'package:go_router/go_router.dart';
import 'package:agroconecta/presentation/screens/screens.dart';
import 'package:agroconecta/presentation/screens/not_found.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/home', builder:  (_, __) => const HomePage()),
    GoRoute(path: '/convocatorias', builder: (_, __) => const ConvocatoriaPage()),
    // agrega aquí más rutas…
  ],

  errorBuilder: (context, state) => NotFoundScreen(
    error: state.error,
    location: state.uri.toString(),
  ),
);
