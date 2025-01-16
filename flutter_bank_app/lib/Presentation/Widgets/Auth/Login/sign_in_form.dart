import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => SignInRepository();
}

class SignInRepository extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  StateMachineController getRiveController(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (controller != null) artboard.addController(controller);
    return controller!;
  }

  void signIn(BuildContext context) {
    setState(() {});
    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        final email = _emailController.text;
        final password = _passwordController.text;

        context.read<LoginBloc>().add(
              LoginButtonPressed(email: email, password: password),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().stream.listen((state) {
      if (state.email != null) {
        context.go('/home');
      } else if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message ??
                  AppLocalizations.of(context)!.errorRegistrarUsuario)),
        );
      }
    });

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.email,
                  style: const TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) => value!.isEmpty
                        ? AppLocalizations.of(context)!.elNombreEsObligatorio
                        : null,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.password,
                  style: const TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) => value!.isEmpty
                        ? AppLocalizations.of(context)!.elNombreEsObligatorio
                        : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () => signIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.textbuttonlogin,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
