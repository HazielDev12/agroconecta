import 'package:agroconecta/features/products/presentation/screens/forgot_password_screen.dart';
import 'package:agroconecta/features/products/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/sign-up', builder: (context, state) => SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
  ],
);
