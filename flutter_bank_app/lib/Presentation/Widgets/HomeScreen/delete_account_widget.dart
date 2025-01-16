import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogAlertaDelete extends StatelessWidget {
  const DialogAlertaDelete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.titledelete),
      content: Text(AppLocalizations.of(context)!.textdelete),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancelar');
          },
          child: Text(AppLocalizations.of(context)!.buttoncancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Aceptar');
          },
          child: Text(AppLocalizations.of(context)!.buttonaceptar),
        ),
      ],
    );
  }
}
