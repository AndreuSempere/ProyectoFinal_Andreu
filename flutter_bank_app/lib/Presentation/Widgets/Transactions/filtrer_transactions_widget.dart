import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final Map<String, dynamic> filters = {
    'descripcion': null,
    'tipo': null,
    'created_at': null,
    'cantidad': null,
  };

  String? selectedDate;

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                labelText: 'Fecha',
                hintText: 'dd/mm/aa',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              controller: TextEditingController(text: selectedDate),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2026),
                );
                if (date != null) {
                  final formattedDate =
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${(date.year % 100).toString().padLeft(2, '0')}';
                  setState(() {
                    selectedDate = formattedDate;
                    filters['created_at'] = formattedDate;
                  });
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
