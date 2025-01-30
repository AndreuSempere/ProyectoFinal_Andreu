import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Presentation/Screens/home_screen.dart';
import 'package:flutter_bank_app/Presentation/Screens/login_screen.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Card/ui/app.dart';
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
      GoRoute(path: '/add_card', builder: (context, state) => const App()),
    ],
    redirect: (context, state) async {
      final isLoggedIn = await sl<SignInRepository>().isLoggedIn();
      return isLoggedIn.fold((_) => '/login', (loggedIn) {
        if (loggedIn == "NO_USER" &&
            !state.matchedLocation.contains("/login")) {
          return "/login";
        } else {
          return state.matchedLocation;
        }
      });
    });
