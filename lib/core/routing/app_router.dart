import 'package:emuladornfc/features/home/presentation/pages/home_page.dart';
import 'package:emuladornfc/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
