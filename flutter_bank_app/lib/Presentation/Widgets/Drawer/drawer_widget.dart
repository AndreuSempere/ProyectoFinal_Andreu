import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Logaout/alerta_logaout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage(); // Cargar la imagen guardada al iniciar
  }

  Future<String> _getUserDirectory(String userEmail) async {
    final directory = await getApplicationDocumentsDirectory();
    final userDir = Directory('${directory.path}/users/$userEmail');

    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }

    return userDir.path;
  }

  Future<void> _loadImage() async {
    final state = context.read<LoginBloc>().state;

    if (state.user != null) {
      final userDir = await _getUserDirectory(state.user!.email);
      final imagePath = '$userDir/avatar_image.png';
      final imageFile = File(imagePath);

      if (await imageFile.exists()) {
        setState(() {
          _imageFile = imageFile;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final state = context.read<LoginBloc>().state;

    if (state.user != null) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final userDir = await _getUserDirectory(state.user!.email);
        final imagePath = '$userDir/avatar_image.png';
        final savedImage = await File(pickedFile.path).copy(imagePath);

        setState(() {
          _imageFile = savedImage;
        });
      }
    }
  }

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
                  decoration: const BoxDecoration(color: Color(0xFF5B0DA8)),
                  currentAccountPicture: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF4B0B8B),
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? Text(
                              state.user!.name.substring(0, 3).toUpperCase(),
                              style: const TextStyle(color: Color(0xFFF2F2F2)),
                            )
                          : null,
                    ),
                  ),
                  accountName: Text(state.user!.name),
                  accountEmail: Text(state.user!.email),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    'Editar perfil',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.security,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    'Privacidad',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.payment,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    'Configurar tarjetas',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Color(0xFFF2F2F2),
                  ),
                  title: Text(
                    'Notificaciones',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFF2F2F2),
                  ),
                ),
                const Spacer(),
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Color(0xFFF2F2F2)),
                      ),
                      Icon(Icons.exit_to_app, color: Color(0xFFF2F2F2)),
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