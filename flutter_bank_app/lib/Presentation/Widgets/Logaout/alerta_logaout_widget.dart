import 'package:flutter/material.dart';

class DialogAlerta extends StatelessWidget {
  const DialogAlerta({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cerrar la sesión'),
      content: const Text(
          'Estas a punto de cerrar la seión.¿Estás seguro de continuar?'),
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
