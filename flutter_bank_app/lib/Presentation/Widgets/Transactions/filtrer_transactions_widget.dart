import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final userId = context.read<LoginBloc>().state.user!.idUser!;

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.titlefiltrer),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.textdescripcion),
              onChanged: (value) {
                filters['descripcion'] = value.trim();
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.textmovimiento),
              items: [
                DropdownMenuItem(
                    value: 'ingreso',
                    child: Text(AppLocalizations.of(context)!.textingreso)),
                DropdownMenuItem(
                    value: 'gasto',
                    child: Text(AppLocalizations.of(context)!.textgasto)),
              ],
              onChanged: (value) {
                filters['tipo'] = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textfecha,
                hintText: 'dd/mm/aa',
                suffixIcon: const Icon(Icons.calendar_today),
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
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}';

                  setState(() {
                    selectedDate = formattedDate;
                    filters['created_at'] = formattedDate;
                  });
                }
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.textcantidad),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                filters['cantidad'] = double.tryParse(value);
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.buttoncancel,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            filters.removeWhere(
                (key, value) => value == null || value.toString().isEmpty);

            context
                .read<TransactionBloc>()
                .add(GetAllTransactions(id: userId, filters: filters));

            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.buttonaplicar,
          ),
        ),
      ],
    );
  }
}
