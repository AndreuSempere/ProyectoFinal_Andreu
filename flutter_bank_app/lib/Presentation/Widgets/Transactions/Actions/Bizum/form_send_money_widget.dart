import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMoneyPage extends StatelessWidget {
  final TextEditingController _targetPhoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _conceptController = TextEditingController();
  final int accountId;

  SendMoneyPage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final myUserState = context.read<LoginBloc>().state;
    final telfUser = myUserState.user!.telf;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 193, 226),
        title: const Text(
          'Enviar Dinero',
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
              'Enviar dinero',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _targetPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Número de teléfono destinatario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
                  _targetPhoneController.text =
                      value.replaceAll(RegExp(r'[^\d]'), '');
                  _targetPhoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _targetPhoneController.text.length));
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad a enviar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _conceptController,
              decoration: InputDecoration(
                labelText: 'Concepto',
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
                  final targetPhoneText = _targetPhoneController.text;
                  final amountText = _amountController.text;
                  final concept = _conceptController.text;

                  // Validar y convertir los campos
                  if (targetPhoneText.isEmpty ||
                      amountText.isEmpty ||
                      concept.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Por favor, completa todos los campos.')),
                    );
                    return;
                  }

                  final targetPhone = int.tryParse(targetPhoneText);
                  final amount = int.tryParse(amountText);

                  if (targetPhone == null || amount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Por favor, introduce valores numéricos válidos.')),
                    );
                    return;
                  }

                  final newBizum = Transaction(
                    account: int.parse(telfUser!),
                    targetAccount: targetPhone,
                    cantidad: amount,
                    descripcion: concept,
                    tipo: 'gasto',
                  );

                  context
                      .read<TransactionBloc>()
                      .add(CreateTransactionsBizum(newBizum));
                  context
                      .read<TransactionBloc>()
                      .add(GetAllTransactions(id: accountId));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Bizum enviado a $targetPhone por $amount€ con concepto: $concept')),
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Enviar Bizum'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
