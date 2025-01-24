import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/Actions/Bizum/form_send_money_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';

class RegisterPhonePage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  RegisterPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final myLoginState = context.read<LoginBloc>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 193, 226),
        title: const Text(
          'Bankify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registra tu número de teléfono',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Número de teléfono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String phoneText = _phoneController.text;

                  if (phoneText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Por favor, introduce tu número de teléfono.'),
                      ),
                    );
                    return;
                  }

                  if (phoneText.length != 9 ||
                      !RegExp(r'^\d+$').hasMatch(phoneText)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'El número de teléfono debe tener 9 dígitos y solo contener números.'),
                      ),
                    );
                    return;
                  }

                  final telf = int.parse(phoneText);
                  final String email = myLoginState.user!.email;
                  final int? idUser = myLoginState.user!.idUser;
                  final String name = myLoginState.user!.name;
                  final String surname = myLoginState.user!.surname;

                  context.read<LoginBloc>().add(
                      UpdateUserEvent(idUser!, name, surname, email, telf));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Número registrado correctamente.'),
                    ),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendMoneyPage()),
                  );
                },
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
