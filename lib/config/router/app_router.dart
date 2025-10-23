import 'package:agroconecta/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/sign-up', builder: (context, state) => SignUpScreen()),
  ],
);
