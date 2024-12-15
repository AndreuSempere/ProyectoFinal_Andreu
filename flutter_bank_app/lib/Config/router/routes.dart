import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Presentation/Screens/HomeScreen/home_screen.dart';
import 'package:flutter_bank_app/Presentation/Screens/Login/pantalla_principal_screen.dart';
import 'package:flutter_bank_app/injection.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (context, state) async {
      final isLoggedIn = await sl<LoginRepository>().isLoggedIn();
      return isLoggedIn.fold((_) => '/login', (loggedIn) {
        if (loggedIn == "NO_USER" &&
            !state.matchedLocation.contains("/login")) {
          return "/login";
        } else {
          return state.matchedLocation;
        }
      });
    });
