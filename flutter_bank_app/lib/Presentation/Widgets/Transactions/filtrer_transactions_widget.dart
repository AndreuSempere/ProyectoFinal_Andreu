import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> filters = {
      'descripcion': null,
      'tipo': null,
      'fecha': null,
      'cantidad': null,
    };

    return AlertDialog(
      title: const Text('Filtrar Transacciones'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {
                filters['descripcion'] = value.trim();
              },
            ),
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Tipo de movimiento'),
              items: const [
                DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
              ],
              onChanged: (value) {
                filters['tipo'] = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Fecha'),
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  filters['fecha'] =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                }
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                filters['cantidad'] = double.tryParse(value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            filters.removeWhere(
                (key, value) => value == null || value.toString().isEmpty);

            context.read<TransactionBloc>().add(GetAllTransactions(filters));
            Navigator.of(context).pop();
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
