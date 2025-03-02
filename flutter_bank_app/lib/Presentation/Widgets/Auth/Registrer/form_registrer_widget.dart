import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/EditUser/template_form_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/OCR/ocr_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  bool _showAdditionalFields = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dniController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha de nacimiento es obligatoria';
    }

    try {
      DateTime birthDate = DateFormat('dd/MM/yyyy').parse(value);
      DateTime currentDate = DateTime.now();

      int age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }

      if (age < 18) {
        return 'Debes ser mayor de 18 años';
      }
    } catch (e) {
      return 'Formato de fecha incorrecto';
    }

    return null;
  }

  Future<void> _processImageExtractText(
      {required ImageSource imageSource}) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: imageSource);

    if (image != null) {
      try {
        final extractedData = await extractDNIData(image.path);
        final String dni = extractedData['dni'] ?? 'No se encontró DNI';
        final String birthDate =
            extractedData['birthDate'] ?? 'No se encontró fecha';

        setState(() {
          if (dni != 'No se encontró DNI' &&
              birthDate != 'No se encontró fecha') {
            _dniController.text = dni;
            _birthDateController.text = birthDate;
            _showAdditionalFields = true;
          } else {
            _showAdditionalFields = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error al extraer datos: $dni, $birthDate')),
            );
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al procesar la imagen: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ninguna imagen')));
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String surname = _surnameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String dni = _dniController.text;

      DateTime formatbirthDate =
          DateFormat('dd/MM/yyyy').parse(_birthDateController.text);
      String BirthDate = DateFormat('dd/MM/yyyy').format(formatbirthDate);

      context.read<LoginBloc>().add(RegisterButtonPressed(
          name, surname, email, password, dni, BirthDate));

      await Future.delayed(const Duration(seconds: 1));
      final state = context.read<LoginBloc>().state;

      if (state.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message ??
                  AppLocalizations.of(context)!
                      .usuarioRegistradoCorrectamente)),
        );
        Navigator.pop(context);
      } else if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message ??
                  AppLocalizations.of(context)!.errorRegistrarUsuario)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al registrar usuario. Inténtalo de nuevo.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PlantillaTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.nameUpdUser,
            icon: Icons.person,
            validatorMsg: AppLocalizations.of(context)!.elNombreEsObligatorio,
          ),
          PlantillaTextField(
            controller: _surnameController,
            label: AppLocalizations.of(context)!.surnameUpdUser,
            icon: Icons.person_outline,
            validatorMsg: AppLocalizations.of(context)!.elApellidoEsObligatorio,
          ),
          PlantillaTextField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            icon: Icons.email,
            validatorMsg: AppLocalizations.of(context)!.introduceUnEmailValido,
            keyboardType: TextInputType.emailAddress,
          ),
          PlantillaTextField(
            controller: _passwordController,
            label: AppLocalizations.of(context)!.password,
            icon: Icons.lock,
            validatorMsg: AppLocalizations.of(context)!
                .laPasswordDebeTenerAlMenos6Caracteres,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 15.0),
          if (!_showAdditionalFields) ...[
            const Text(
              'Elige una fuente para escanear el DNI',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _processImageExtractText(
                          imageSource: ImageSource.gallery),
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Subir desde galería'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        textStyle: const TextStyle(fontSize: 16.0),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _processImageExtractText(
                          imageSource: ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Abrir cámara'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        textStyle: const TextStyle(fontSize: 16.0),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_showAdditionalFields) ...[
            PlantillaTextField(
              controller: _dniController,
              label: 'DNI',
              icon: Icons.assignment_ind,
              validatorMsg: 'El DNI es obligatorio',
            ),
            PlantillaTextField(
              controller: _birthDateController,
              label: 'Fecha de nacimiento',
              icon: Icons.calendar_today,
              validatorMsg: 'La fecha de nacimiento es obligatoria',
              customValidator: _validateBirthDate,
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 188, 193, 203),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    elevation: 5,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.buttoncancel,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 174, 192, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    elevation: 5,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.buttonguardar,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
