import 'package:flutter/material.dart';

class PlantillaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? validatorMsg;
  final TextInputType keyboardType;
  final String? Function(String?)? customValidator;

  const PlantillaTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validatorMsg,
    this.keyboardType = TextInputType.text,
    this.customValidator,
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
          if (value == null || value.isEmpty) {
            return validatorMsg;
          }
          if (customValidator != null) {
            return customValidator!(value);
          }
          return null;
        },
      ),
    );
  }
}
