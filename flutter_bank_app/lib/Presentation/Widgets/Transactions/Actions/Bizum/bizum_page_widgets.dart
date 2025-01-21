import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/Actions/Bizum/form_send_money_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/Actions/Bizum/registrer_phone_page_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BizumPage extends StatelessWidget {
  const BizumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myLoginState = context.read<LoginBloc>().state;
    final int telf = myLoginState.user?.telf ?? 0;

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPhonePage(),
                    ),
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
                      builder: (context) => SendMoneyPage(),
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
