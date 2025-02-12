import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterDialog extends StatefulWidget {
  final Function(int) onFiltersApplied;
  final Map<String, dynamic> currentFilters;

  const FilterDialog({
    super.key,
    required this.onFiltersApplied,
    required this.currentFilters,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Map<String, dynamic> filters = {};
  String? selectedDate;
  String? selectedTipo;
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filters = widget.currentFilters;

    descripcionController.text = filters['descripcion'] ?? '';
    cantidadController.text = filters['cantidad']?.toString() ?? '';
    fechaController.text = filters['created_at'] ?? '';
    selectedTipo = filters['tipo'];
  }

  void _clearFilters() {
    setState(() {
      filters.forEach((key, value) => filters[key] = null);
      selectedDate = null;
      selectedTipo = null;
      descripcionController.clear();
      cantidadController.clear();
      fechaController.clear();
    });
    widget.onFiltersApplied(0);
  }

  bool _hasFilters() {
    return filters.values
        .any((value) => value != null && value.toString().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<LoginBloc>().state.user!.idUser!;

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.titlefiltrer,
        style: TextStyle(fontSize: 14),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.textdescripcion),
              onChanged: (value) => setState(() => filters['descripcion'] =
                  value.trim().isEmpty ? null : value.trim()),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.textmovimiento),
              value: selectedTipo,
              items: [
                DropdownMenuItem(
                    value: 'ingreso',
                    child: Text(AppLocalizations.of(context)!.textingreso)),
                DropdownMenuItem(
                    value: 'gasto',
                    child: Text(AppLocalizations.of(context)!.textgasto)),
              ],
              onChanged: (value) => setState(() {
                selectedTipo = value;
                filters['tipo'] = value;
              }),
            ),
            SizedBox(height: 10),
            TextField(
              controller: fechaController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textfecha,
                hintText: 'dd/mm/aa',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
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
                    fechaController.text = formattedDate;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: cantidadController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.textcantidad),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {
                filters['cantidad'] = double.tryParse(value);
              }),
            ),
          ],
        ),
      ),
      actions: [
        if (!_hasFilters())
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.buttoncancel),
            ),
          ),
        if (_hasFilters())
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _clearFilters();
                filters.removeWhere(
                    (key, value) => value == null || value.toString().isEmpty);
                context
                    .read<TransactionBloc>()
                    .add(GetAllTransactions(id: userId, filters: filters));
                int filterCount = filters.values
                    .where(
                        (value) => value != null && value.toString().isNotEmpty)
                    .length;
                widget.onFiltersApplied(filterCount);
                Navigator.of(context).pop(filters);
              },
              child: Text(AppLocalizations.of(context)!.buttonBorrarFiltros),
            ),
          ),
        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              filters.removeWhere(
                  (key, value) => value == null || value.toString().isEmpty);

              context
                  .read<TransactionBloc>()
                  .add(GetAllTransactions(id: userId, filters: filters));

              int filterCount = filters.values
                  .where(
                      (value) => value != null && value.toString().isNotEmpty)
                  .length;
              widget.onFiltersApplied(filterCount);
              Navigator.of(context).pop(filters);
            },
            child: Text(AppLocalizations.of(context)!.buttonaplicar),
          ),
        ),
      ],
    );
  }
}
