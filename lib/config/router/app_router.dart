import 'package:agroconecta/features/auth/presentation/screens/screens.dart';
import 'package:agroconecta/features/products/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, _) => LoginScreen()),
    GoRoute(path: '/home', builder: (_, _) => HomePage()),
    GoRoute(path: '/sign-up', builder: (_, _) => SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
  ],
);
