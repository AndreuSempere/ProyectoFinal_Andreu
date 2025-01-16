import 'package:flutter/material.dart';

class PlantillaAddTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? validatorMsg;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const PlantillaAddTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validatorMsg,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        validator: (value) {
          if (validator != null) {
            return validator!(
                value); // Usa el validador personalizado si existe
          }
          if (value == null || value.isEmpty) {
            return validatorMsg; // Usa el mensaje predeterminado
          }
          return null;
        },
      ),
    );
  }
}
