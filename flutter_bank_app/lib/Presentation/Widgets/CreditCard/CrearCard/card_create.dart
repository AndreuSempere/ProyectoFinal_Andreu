import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bank_app/Config/Theme/card_colors.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/flip_card.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/CrearCard/Style/my_appbar.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_back_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_front_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/CrearCard/expiration_date_formatter.dart';
import 'package:flutter_bank_app/core/generate_number_random_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/card_wallet_widget.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';

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

  @override
  void initState() {
    super.initState();
    creditCard = CreditCardEntity(
      cardHolderName: 'CARDHOLDER NAME',
      numero_tarjeta: GenerateAccountNumber.generate(),
      fecha_expiracion: '00/0000',
      cardCvv: 000,
      cardColor: selectedColorIndex,
      tipo_tarjeta: widget.cardType,
      id_cuenta: widget.accountId,
    );
    _setupListeners();
  }

  void _setupListeners() {
    holderNameController.addListener(_updateState);
    expirationController.addListener(_updateState);
    cvvController.addListener(_updateState);
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
        fecha_expiracion: _convertExpirationDate(expirationController.text),
        cardCvv: int.tryParse(cvvController.text.padLeft(3, '0')) ?? 0,
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
      body: ListView(
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
                child: _buildTextField(
                  expirationController,
                  'MM/YYYY',
                  isNumeric: true,
                  maxLength: 7,
                  inputFormatters: [ExpirationDateFormatter()],
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField(cvvController, 'CVV',
                    isNumeric: true, maxLength: 3),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildColorPicker(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveCard,
            child: const Text('Guardar Tarjeta'),
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

  void _saveCard() {
    if (_validateInputs()) {
      String expirationDate = creditCard.fecha_expiracion!;
      creditCard = creditCard.copyWith(fecha_expiracion: expirationDate);

      context.read<CreditCardBloc>().add(CreateCreditCard(creditCard));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CardWallet()));
    }
  }

  bool _validateInputs() {
    if (holderNameController.text.isEmpty ||
        expirationController.text.length != 7 ||
        cvvController.text.length != 3) {
      _showErrorDialog("Por favor, ingresa todos los datos correctamente.");
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
