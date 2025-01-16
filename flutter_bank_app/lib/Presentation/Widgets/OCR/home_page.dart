import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bank_app/Presentation/Widgets/OCR/picker_option_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Variables para almacenar texto extraído y la info del DNI
  String _extractedText = '';
  String _dniInfo = '';

  /// Función para seleccionar una imagen desde la galería o la cámara
  Future<File?> _pickerImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Permite recortar la imagen seleccionada
  Future<CroppedFile?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedfile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedfile != null) {
      return croppedfile;
    }

    return null;
  }

  /// Procesa la imagen y extrae texto usando OCR
  Future<String> _recognizeTextFromImage({required String imgPath}) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final image = InputImage.fromFile(File(imgPath));
    final recognized = await textRecognizer.processImage(image);

    // Extraer información del DNI
    _dniInfo = _extractDNIInfo(recognized.text);

    // Extraer la fecha de nacimiento
    String birthDate = _extractDateOfBirth(recognized.text);

    return '${recognized.text}\nFecha de nacimiento: $birthDate'; // Devuelve el texto con la fecha de nacimiento

    // return recognized.text;
  }

  /// Valida el DNI español
  bool _isValidDNIES(String dni) {
    const String validLetters = "TRWAGMYFPDXBNJZSQVHLCKE";

    // Asegúrate de que tenga 8 números seguidos de una letra
    RegExp dniRegExp = RegExp(r'^(\d{8})([A-Z])$');
    Match? match = dniRegExp.firstMatch(dni);

    if (match != null) {
      String numberPart = match.group(1)!; // Los 8 dígitos
      String letterPart = match.group(2)!; // La letra

      // Calcular la letra esperada
      int number = int.parse(numberPart);
      String expectedLetter = validLetters[number % 23];

      return letterPart == expectedLetter;
    }
    return false;
  }

  /// Corrige posibles errores del OCR
  String _sanitizeDNIES(String text) {
    // Reemplaza caracteres que suelen ser mal interpretados
    return text
        .replaceAll('O', '0') // Cambia "O" (letra) por "0"
        .replaceAll('I', '1') // Cambia "I" (letra) por "1"
        .replaceAll('B', '8') // Cambia "B" (letra) por "8"
        .toUpperCase(); // Asegúrate de que todo esté en mayúsculas.
  }

  /// Extrae y valida el DNI del texto
  String _extractDNIInfo(String recognizedText) {
    RegExp dniRegExp =
        RegExp(r'\b\d{8}[A-Z]\b'); // Formato: 8 números + 1 letra
    Match? match = dniRegExp.firstMatch(_sanitizeDNIES(recognizedText));

    if (match != null) {
      String dni = match.group(0) ?? '';
      return _isValidDNIES(dni) ? dni : 'DNI inválido';
    }
    return 'No se encontró un DNI válido';
  }

  /// Función para extraer la fecha de nacimiento del texto
  String _extractDateOfBirth(String recognizedText) {
    // Dividimos el texto por líneas
    List<String> lines = recognizedText.split('\n');

    for (int i = 0; i < lines.length; i++) {
      // Verificamos si la línea actual contiene "Nacimiento" o "Naiximent"
      if (lines[i]
          .contains(RegExp(r'Nacimiento|Naiximent', caseSensitive: false))) {
        // Si existe una línea siguiente, buscamos la fecha allí
        if (i + 1 < lines.length) {
          String possibleDateLine = lines[i + 1];

          // Expresión regular para capturar formato de fecha DD MM AAAA
          RegExp dateRegExp = RegExp(r'(\d{2})\s*(\d{2})\s*(\d{4})');
          Match? match = dateRegExp.firstMatch(possibleDateLine);

          if (match != null) {
            // Extraemos y formateamos la fecha
            String day = match.group(1)!;
            String month = match.group(2)!;
            String year = match.group(3)!;
            return '$day/$month/$year'; // Formato DD/MM/AAAA
          }
        }
      }
    }

    return 'No se encontró una fecha de nacimiento válida';
  }

  /// Procesa la imagen seleccionada y extrae texto
  Future<void> _processImageExtractText({
    required ImageSource imageSource,
  }) async {
    final imageFile = await _pickerImage(source: imageSource);

    if (imageFile == null) return;

    final croppedImage = await _cropImage(
      imageFile: imageFile,
    );

    if (croppedImage == null) return;

    final recognizedText = await _recognizeTextFromImage(
      imgPath: croppedImage.path,
    );

    setState(() {
      _extractedText = recognizedText;
    });
  }

  /// Copia el texto extraído al portapapeles
  void _copyToClipBoard() {
    Clipboard.setData(ClipboardData(text: _extractedText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copiado al portapapeles'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter OCR')),
      body: Column(
        children: [
          const Text(
            'Selecciona una opción',
            style: TextStyle(fontSize: 22.0),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PickerOptionWidget(
                  label: 'Desde galería',
                  color: Colors.blueAccent,
                  icon: Icons.image_outlined,
                  onTap: () => _processImageExtractText(
                    imageSource: ImageSource.gallery,
                  ),
                ),
                const SizedBox(width: 10.0),
                PickerOptionWidget(
                  label: 'Desde cámara',
                  color: Colors.redAccent,
                  icon: Icons.camera_alt_outlined,
                  onTap: () => _processImageExtractText(
                    imageSource: ImageSource.camera,
                  ),
                ),
              ],
            ),
          ),
          if (_extractedText.isNotEmpty) ...{
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Texto extraído',
                    style: TextStyle(fontSize: 22.0),
                  ),
                  IconButton(
                    onPressed: _copyToClipBoard,
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      children: [
                        Text(_extractedText),
                        const SizedBox(height: 20),
                        Text(
                          'Información del DNI: $_dniInfo',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          },
        ],
      ),
    );
  }
}
