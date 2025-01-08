import 'package:flutter/material.dart';

class DialogAlertaDelete extends StatelessWidget {
  const DialogAlertaDelete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar cuenta'),
      content: const Text(
          'Estas a punto de eliminar la cuenta.¿Estás seguro de continuar?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancelar');
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Aceptar');
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
