import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bank_app/Presentation/Screens/home_screen.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/plantilla_add_money_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMoneyPage extends StatelessWidget {
  final int accountId;

  AddMoneyPage({super.key, required this.accountId});

  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Bankify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cómo añadir dinero a mi cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              PlantillaAddTextField(
                controller: _cantidadController,
                label: 'Introduce la cantidad a añadir',
                icon: Icons.monetization_on,
                validatorMsg: 'Introduce una cantidad válida',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo no puede estar vacío';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad <= 0) {
                    return 'Introduce una cantidad válida (entero positivo)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PlantillaAddTextField(
                controller: _descriptionController,
                label: 'Añade un concepto',
                icon: Icons.description,
                validatorMsg: 'Introduce un texto válido',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final cantidad = int.parse(_cantidadController.text);
                        final descripcion = _descriptionController.text;

                        const String tipo = "ingreso";

                        final newTransaction = Transaction(
                          account: accountId,
                          cantidad: cantidad,
                          descripcion: descripcion,
                          tipo: tipo,
                        );

                        context
                            .read<TransactionBloc>()
                            .add(CreateTransactions(newTransaction));

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
