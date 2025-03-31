import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/NFC/nfc_service.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/Actions/AddMoney/template_add_money_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AddMoneyPage extends StatefulWidget {
  final int accountId;

  const AddMoneyPage({super.key, required this.accountId});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cardNumberController = TextEditingController();

  final NFCService _nfcService = NFCService();

  bool setupComplete = false;
  int setupStatusIndex = 0;
  String setupMessage = "Initializing SDK..";
  bool isScanning = false;
  bool cardScanned = false;

  @override
  void initState() {
    super.initState();
    _initializeNFC();
  }

  Future<void> _initializeNFC() async {
    setupStatusIndex = await _nfcService.checkNFCStatus();
    setState(() {
      setupMessage = setupStatusIndex == 0
          ? "NFC no disponible"
          : setupStatusIndex == 1
              ? "Activa NFC y reinicia la app"
              : "NFC listo para escanear";
      setupComplete = true;
    });
  }

  Future<void> _startCardScan() async {
    if (isScanning) return;

    setState(() {
      isScanning = true;
    });

    final result = await _nfcService.initCardScanListener();
    if (result['success'] == true) {
      final cardData = result['cardData'];
      try {
        final maskedCardNumber = _nfcService.maskCardNumber(cardData);
        setState(() {
          _cardNumberController.text = maskedCardNumber;
          cardScanned = true;
          isScanning = false;
        });
        debugPrint("startCard1");
      } catch (e) {
        print("Error al enmascarar el número de tarjeta: $e");
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['error'] ?? "Error escaneando tarjeta")),
        );
      }
      setState(() {
        isScanning = false;
      });
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _descriptionController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 193, 226),
        title: const Text(
          'Bankify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.titleAddmoney,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.textAddmoney,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[600],
                  ),
                ),
                const SizedBox(height: 24),
                if (!setupComplete)
                  const Center(child: CircularProgressIndicator())
                else if (setupStatusIndex != 2)
                  Center(
                    child: Text(
                      setupMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (!cardScanned) // Mostrar solo si no se escaneó la tarjeta
                            ElevatedButton.icon(
                              onPressed: !setupComplete || isScanning
                                  ? null
                                  : _startCardScan,
                              icon: const Icon(Icons.nfc),
                              label: isScanning
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    )
                                  : const Text("Escanear tarjeta"),
                            ),
                          if (cardScanned) ...[
                            PlantillaAddTextField(
                              controller: _cardNumberController,
                              label: "Número de tarjeta",
                              icon: Icons.credit_card,
                              enabled: false,
                            ),
                            const SizedBox(height: 16),
                            PlantillaAddTextField(
                              controller: _cantidadController,
                              label:
                                  AppLocalizations.of(context)!.textcantidadadd,
                              icon: Icons.monetization_on,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo no puede estar vacío';
                                }
                                final cantidad = int.tryParse(value);
                                if (cantidad == null || cantidad <= 0) {
                                  return 'Introduce una cantidad válida (entero positivo)';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            PlantillaAddTextField(
                              controller: _descriptionController,
                              label:
                                  AppLocalizations.of(context)!.textconceptoadd,
                              icon: Icons.description,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo no puede estar vacío';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.white),
                                  label: Text(
                                    AppLocalizations.of(context)!.buttoncancel,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final cantidad =
                                          int.parse(_cantidadController.text);
                                      final descripcion =
                                          _descriptionController.text;

                                      final newTransaction = Transaction(
                                        account: widget.accountId,
                                        cantidad: cantidad,
                                        descripcion: descripcion,
                                        tipo: "ingreso",
                                      );

                                      context.read<TransactionBloc>().add(
                                          CreateTransactions(newTransaction));

                                      context.go('/home');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  icon: const Icon(Icons.check,
                                      color: Colors.white),
                                  label: Text(
                                    AppLocalizations.of(context)!.buttonguardar,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
