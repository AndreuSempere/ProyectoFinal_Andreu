import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Config/Theme/theme.dart';
import 'package:flutter_bank_app/Config/router/routes.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/language/language_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/language/language_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Services/notification_service.dart';
import 'package:flutter_bank_app/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env");
    debugPrint('.env cargado correctamente');
  } catch (e) {
    debugPrint('Error al cargar el archivo .env: $e');
  }

  try {
    await Firebase.initializeApp(
      // name: 'bankifyApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase inicializado correctamente.');
  } catch (e, stack) {
    debugPrint('Error al inicializar Firebase: $e');
    debugPrint('$stack');
  }

  await configureDependencies();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LoginBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<AccountBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<TransactionBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<LanguageBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<BiometricAuthBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<CreditCardBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<TradingBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<InvestmentsBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Bankify',
            theme: appTheme,
            locale: state.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}

OutlineInputBorder defaultInputBorder = const OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
