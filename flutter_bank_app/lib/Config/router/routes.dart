import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Presentation/Screens/home_screen.dart';
import 'package:flutter_bank_app/Presentation/Screens/login_screen.dart';
import 'package:flutter_bank_app/Presentation/Screens/transactions_screen.dart';
import 'package:flutter_bank_app/Presentation/Screens/creditCard_screen.dart';
import 'package:flutter_bank_app/injection.dart';
import 'package:flutter_bank_app/main.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
    initialLocation: '/login',
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/transactions',
        builder: (context, state) {
          Account account = state.extra as Account;
          return TransactionInfoPage(
            accountId: account.idCuenta!,
            description: account.description,
            numeroCuenta: account.numeroCuenta!,
          );
        },
      ),
      GoRoute(
        path: '/add_card',
        builder: (context, state) {
          final int accountId = state.extra as int;
          return HomeCreditCard(accountId: accountId);
        },
      ),
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
