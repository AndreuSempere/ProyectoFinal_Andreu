import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogAlerta extends StatelessWidget {
  const DialogAlerta({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.cerrarSesionTitle),
      content: Text(AppLocalizations.of(context)!.cerrarSesionConfirmacion),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancelar');
          },
          child: Text(AppLocalizations.of(context)!.cerrarSesionConfirmacionNo),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Aceptar');
          },
          child: Text(AppLocalizations.of(context)!.cerrarSesionConfirmacionSi),
        ),
      ],
    );
  }
}
