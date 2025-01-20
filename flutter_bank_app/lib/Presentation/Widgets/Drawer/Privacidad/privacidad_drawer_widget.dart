import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/Privacidad/change_password_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/Privacidad/change_language_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacidadDrawer extends StatelessWidget {
  const PrivacidadDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        AppLocalizations.of(context)!.privacidad,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context: context,
            label: AppLocalizations.of(context)!.changeLanguage,
            icon: Icons.language,
            onPressed: () => _showLanguageSelectionDialog(context),
          ),
          const SizedBox(height: 16),
          _buildButton(
            context: context,
            label: AppLocalizations.of(context)!.cambPassword,
            icon: Icons.lock,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const PasswordCambiarDialog(),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildButton(
            context: context,
            label: AppLocalizations.of(context)!.activarHuellaID,
            icon: Icons.fingerprint,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.buttoncancel),
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const ChangeLanguageDialog();
      },
    );
  }
}
