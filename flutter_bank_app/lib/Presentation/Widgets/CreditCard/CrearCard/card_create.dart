import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bank_app/Config/Theme/card_colors.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/flip_card.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/CrearCard/Style/my_appbar.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_back_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_front_widget.dart';
import 'package:flutter_bank_app/core/generate_number_random_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/card_wallet_widget.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'dart:math';

class CardCreate extends StatefulWidget {
  final String cardType;
  final int accountId;

  const CardCreate(
      {super.key, required this.cardType, required this.accountId});

  @override
  _CardCreateState createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  final GlobalKey<FlipCardState> animatedStateKey = GlobalKey<FlipCardState>();
  final TextEditingController holderNameController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  int selectedColorIndex = 0;
  late CreditCardEntity creditCard;
  late String generatedExpirationDate;
  late int generatedCvv;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Generate random CVV (3 digits)
    generatedCvv = _generateCvv();
    // Generate expiration date (4 years from now)
    generatedExpirationDate = _generateExpirationDate();
    
    creditCard = CreditCardEntity(
      cardHolderName: 'CARDHOLDER NAME',
      numero_tarjeta: GenerateAccountNumber.generate(),
      fecha_expiracion: generatedExpirationDate,
      cardCvv: generatedCvv,
      cardColor: selectedColorIndex,
      tipo_tarjeta: widget.cardType,
      id_cuenta: widget.accountId,
    );
    
    // Set the generated values to the controllers for display
    expirationController.text = _formatExpirationDateForDisplay(generatedExpirationDate);
    cvvController.text = generatedCvv.toString().padLeft(3, '0');
    
    _setupListeners();
  }

  // Generate a random 3-digit CVV
  int _generateCvv() {
    final random = Random();
    return random.nextInt(900) + 100; // Generates a number between 100-999
  }

  // Generate expiration date (4 years from now)
  String _generateExpirationDate() {
    final now = DateTime.now();
    final expiryYear = now.year + 4;
    final expiryMonth = now.month.toString().padLeft(2, '0');
    return '$expiryYear/$expiryMonth';
  }

  // Format the expiration date for display (MM/YYYY)
  String _formatExpirationDateForDisplay(String dbFormatDate) {
    List<String> parts = dbFormatDate.split('/');
    if (parts.length == 2) {
      return '${parts[1]}/${parts[0]}';
    }
    return dbFormatDate;
  }

  void _setupListeners() {
    holderNameController.addListener(_updateState);
  }

  @override
  void dispose() {
    holderNameController.dispose();
    expirationController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      creditCard = creditCard.copyWith(
        cardHolderName: holderNameController.text.isNotEmpty
            ? holderNameController.text
            : 'CARDHOLDER NAME',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        appBarTitle: 'Create Card',
        leadingIcon: Icons.arrow_back,
        context: context,
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: FlipCard(
                  key: animatedStateKey,
                  front: CardFront(card: creditCard),
                  back: CardBack(
                    cardColor: selectedColorIndex,
                    cardCvv: creditCard.cardCvv!,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(holderNameController, 'Nombre del Propietario'),
              _buildNonEditableField(
                  'Número de Tarjeta', creditCard.numero_tarjeta),
              Row(
                children: [
                  Expanded(
                    child: _buildNonEditableField(
                      'Fecha de Expiración (MM/YYYY)',
                      expirationController.text,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNonEditableField(
                      'CVV',
                      cvvController.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildColorPicker(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveCard,
                child: _isSaving 
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Guardando...'),
                        ],
                      )
                    : const Text('Guardar Tarjeta'),
              ),
            ],
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNonEditableField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(labelText: label, counterText: ''),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false,
      int? maxLength,
      List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(labelText: label, counterText: ''),
      onChanged: (value) => setState(() {}),
    );
  }

  String _convertExpirationDate(String expirationDate) {
    List<String> parts = expirationDate.split('/');
    if (parts.length == 2) {
      return '${parts[1]}/${parts[0]}';
    }
    return expirationDate;
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona un color:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(CardColor.baseColors.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColorIndex = index;
                  creditCard =
                      creditCard.copyWith(cardColor: selectedColorIndex);
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: CardColor.baseColors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedColorIndex == index
                        ? Colors.black
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: selectedColorIndex == index
                    ? const Icon(Icons.check, color: Colors.white, size: 15)
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  void _saveCard() async {
    if (_validateInputs()) {
      setState(() {
        _isSaving = true;
      });

      try {
        // Ensure we're using the correct format for the expiration date
        String expirationDate = creditCard.fecha_expiracion!;
        creditCard = creditCard.copyWith(
          cardHolderName: holderNameController.text,
          fecha_expiracion: expirationDate
        );

        // Dispatch the event to create the credit card
        context.read<CreditCardBloc>().add(CreateCreditCard(creditCard));
        
        // Add a small delay to ensure the card is saved
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Navigate to the card wallet screen and trigger loading of cards
        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const CardWallet())
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
          _showErrorDialog("Error al guardar la tarjeta: ${e.toString()}");
        }
      }
    }
  }

  bool _validateInputs() {
    if (holderNameController.text.isEmpty) {
      _showErrorDialog("Por favor, ingresa el nombre del propietario correctamente.");
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
