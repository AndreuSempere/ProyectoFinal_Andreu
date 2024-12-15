import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
// import 'package:rive/rive.dart'; // Comentado porque no se utiliza en esta versión

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // bool isShowLoading = false; // Comentado: no se utiliza
  // bool isShowConfetti = false; // Comentado: no se utiliza

  // late SMITrigger check; // Comentado: no se utiliza
  // late SMITrigger error; // Comentado: no se utiliza
  // late SMITrigger reset; // Comentado: no se utiliza
  // late SMITrigger confetti; // Comentado: no se utiliza

  // Método para inicializar el controlador de Rive. Comentado porque no se usa en esta versión
  // StateMachineController getRiveController(Artboard artboard) {
  //   final controller =
  //       StateMachineController.fromArtboard(artboard, "State Machine 1");
  //   if (controller != null) artboard.addController(controller);
  //   return controller!;
  // }

  void signIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Dispara el evento de inicio de sesión al bloc
      context.read<LoginBloc>().add(
            LoginButtonPressed(email: email, password: password),
          );
      // Navega a la página de inicio
      context.go('/home');
      // Cierra el diálogo actual
      Navigator.pop(context);
    } else {
      // Aquí podrías añadir lógica adicional para manejar errores
      // Por ejemplo: mostrar un mensaje o habilitar un trigger
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email",
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      value!.isEmpty ? "El campo es obligatorio" : null,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    ),
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      value!.isEmpty ? "El campo es obligatorio" : null,
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
                  label: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
        // Animaciones comentadas: se habilitarán más tarde
        // if (isShowLoading)
        //   CustomPositioned(
        //     child: RiveAnimation.asset(
        //       "assets/RiveAssets/check.riv",
        //       onInit: (artboard) {
        //         final controller = getRiveController(artboard);
        //         check = controller.findSMI("Check") as SMITrigger;
        //         error = controller.findSMI("Error") as SMITrigger;
        //         reset = controller.findSMI("Reset") as SMITrigger;
        //       },
        //     ),
        //   ),
        // if (isShowConfetti)
        //   CustomPositioned(
        //     child: Transform.scale(
        //       scale: 6,
        //       child: RiveAnimation.asset(
        //         "assets/RiveAssets/confetti.riv",
        //         onInit: (artboard) {
        //           final controller = getRiveController(artboard);
        //           confetti =
        //               controller.findSMI("Trigger explosion") as SMITrigger;
        //         },
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}

// Componente CustomPositioned: no modificado
class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(height: size, width: size, child: child),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
