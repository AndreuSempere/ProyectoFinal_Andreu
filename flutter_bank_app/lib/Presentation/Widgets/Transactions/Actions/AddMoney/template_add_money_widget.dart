import 'package:flutter/material.dart';

class PlantillaAddTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool? enabled;
  final String? validatorMsg;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const PlantillaAddTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validatorMsg,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled,
  });

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
            return validator!(value);
          }
          if (value == null || value.isEmpty) {
            return validatorMsg;
          }
          return null;
        },
      ),
    );
  }
}
