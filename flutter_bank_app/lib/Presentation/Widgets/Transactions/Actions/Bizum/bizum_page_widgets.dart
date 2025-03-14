import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/Actions/Bizum/form_send_money_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BizumPage extends StatelessWidget {
  final int accountId;

  const BizumPage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final myLoginState = context.read<LoginBloc>().state;
    final Object telf = myLoginState.user?.telf ?? 0;

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
              'Bienvenido a Bizum',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (telf == 0) ...[
              const Text(
                'Parece que no tienes un número de teléfono registrado para usar Bizum.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      final TextEditingController phoneController =
                          TextEditingController();
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Registra tu número de teléfono',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: phoneController,
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
                                  String phoneText = phoneController.text;

                                  if (phoneText.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Por favor, introduce tu número de teléfono.'),
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
                                  final String surname =
                                      myLoginState.user!.surname;

                                  context.read<LoginBloc>().add(UpdateUserEvent(
                                      idUser!, name, surname, email, telf));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Número registrado correctamente.'),
                                    ),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SendMoneyPage(accountId: accountId),
                                    ),
                                  );
                                },
                                child: const Text('Registrar'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Registrar Número de Teléfono'),
              ),
            ] else ...[
              const Text(
                'Puedes usar Bizum para enviar dinero.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendMoneyPage(accountId: accountId),
                    ),
                  );
                },
                child: const Text('Enviar Dinero'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
