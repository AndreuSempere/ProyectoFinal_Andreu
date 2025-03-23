import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/EditUser/update_user_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/Privacidad/privacidad_drawer_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/Logout/alert_logout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 113, 112, 110),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.user == null) {
            return const Center(
              child: Text('No hay información del usuario'),
            );
          } else {
            return Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 58, 57, 59)),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 195, 112, 177),
                    child: Text(
                      state.user!.name.substring(0, 3).toUpperCase(),
                      style: const TextStyle(color: Color(0xFFF2F2F2)),
                    ),
                  ),
                  accountName: Text(state.user!.name),
                  accountEmail: Text(state.user!.email),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                  onTap: () {
                    context.go('/home');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.editarPerfil,
                    style: const TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const EditarUser();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.security,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.privacidad,
                    style: const TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const PrivacidadDrawer();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.notificaciones,
                    style: const TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                ),
                const Spacer(),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.cerrarSesion,
                        style: const TextStyle(color: Color(0xFFF2F2F2)),
                      ),
                      const Icon(Icons.exit_to_app, color: Color(0xFFF2F2F2)),
                    ],
                  ),
                  onTap: () async {
                    final resultado = await _mostrarAlerta(context);

                    if (resultado == "Aceptar") {
                      context.read<LoginBloc>().add(LogoutButtonPressed());
                      context
                          .read<BiometricAuthBloc>()
                          .add(LoadBiometricStatus());
                      context.go('/login');
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
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
