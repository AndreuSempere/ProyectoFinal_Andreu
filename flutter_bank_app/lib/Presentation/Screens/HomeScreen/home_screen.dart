import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/drawer_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Bankify')),
        ),
        endDrawer: const DrawerWidget(),
        body: FutureBuilder<String?>(
          future: _getUserEmail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar el usuario'));
            } else {
              final email = snapshot.data ?? 'Usuario desconocido';
              context.read<LoginBloc>().add(FetchUserDataEvent(email: email));
              return Center(
                child: Text(
                  'Bienvenido, $email',
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
