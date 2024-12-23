import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Logaout/alerta_logaout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  Future<String> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email') ?? 'Usuario desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar el usuario'));
          } else {
            final email = snapshot.data;
            return Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: NetworkImage(
                                "https://www.guelphhumber.ca/themes/custom/nc_theme/src/img/placeholder-avatar.png"),
                            height: 80,
                          ),
                          Text('Usuario: $email'),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ListTile(
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Cerrar sesión'),
                        Icon(Icons.exit_to_app),
                      ],
                    ),
                    onTap: () async {
                      final resultado = await _mostrarAlerta(context);
                      if (resultado == "Aceptar") {
                        context.read<LoginBloc>().add(LogoutButtonPressed());
                        context.go('/login');
                      }
                    },
                  ),
                ],
              ),
            );
          }
        });
  }
}

Future<String?> _mostrarAlerta(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return const DialogAlerta();
    },
  );
}
