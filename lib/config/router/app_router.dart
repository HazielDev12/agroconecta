import 'package:agroconecta/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';


// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/convocatorias',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/convocatorias', builder: (context, state) => ConvocatoriaPage()),
  ],
);
