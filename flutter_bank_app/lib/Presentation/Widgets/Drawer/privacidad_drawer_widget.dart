import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/cambiar_contrase%C3%B1a_widget.dart';

class PrivacidadDrawer extends StatelessWidget {
  const PrivacidadDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Privacidad',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context: context,
            label: 'Cambiar Contraseña',
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
            label: 'Activar Desbloqueo Face ID / Huella',
            icon: Icons.fingerprint,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
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
}
