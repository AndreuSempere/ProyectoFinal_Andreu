import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TransactionPage extends StatefulWidget {
  final int accountId;

  const TransactionPage({super.key, required this.accountId});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAccountController = TextEditingController();

  String _transactionType = 'own';
  String? _fromAccount;
  String? _toAccount;

  final Map<int, String> tipoCuenta = {
    1: "Cuenta corriente",
    2: "Cuenta de ahorro",
    3: "Cuenta de inversión",
  };

  @override
  Widget build(BuildContext context) {
    final myAccountState = context.read<AccountBloc>().state;
    final accounts = myAccountState.accounts;

    return BlocListener<TransactionBloc, TransactionState>(
      listenWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Procesando transferencia..."),
              backgroundColor: Colors.blue,
            ),
          );
        } else if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (!state.isLoading && state.errorMessage.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.transactionsuccessful),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {});
          context.go('/home');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseTransactionType,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _transactionType,
                onChanged: (value) {
                  setState(() {
                    _transactionType = value!;
                    _fromAccount = null;
                    _toAccount = null;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'own',
                    child: Text(AppLocalizations.of(context)!.toOwnAccount),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text(AppLocalizations.of(context)!.toOtherAccount),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_transactionType == 'own') ...[
                Text(
                  AppLocalizations.of(context)!.chooseFromAccount,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _fromAccount ?? widget.accountId.toString(),
                  onChanged: (value) {
                    setState(() {
                      _fromAccount = value!;
                    });
                  },
                  hint: Text(AppLocalizations.of(context)!.selectFromAccount),
                  items: accounts.map((account) {
                    return DropdownMenuItem<String>(
                      value: account.idCuenta.toString(),
                      child: Text(
                        account.numeroCuenta!,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.chooseToAccount,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _toAccount,
                  onChanged: (value) {
                    setState(() {
                      _toAccount = value!;
                    });
                  },
                  hint: Text(AppLocalizations.of(context)!.selectToAccount),
                  isExpanded: true,
                  items: accounts.map((account) {
                    return DropdownMenuItem<String>(
                      value: account.idCuenta.toString(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tipoCuenta[account.accountType] ?? "Desconocido",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            account.numeroCuenta!,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (_transactionType == 'other') ...[
                Text(
                  AppLocalizations.of(context)!.targetAccount,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _targetAccountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.enterTargetAccount,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.enteramount,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.amount,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.description,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterdescription,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Ajuste de espacio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = _amountController.text;
                    final description = _descriptionController.text;
                    final targetAccount = _targetAccountController.text;

                    final fromAccount =
                        _fromAccount ?? widget.accountId.toString();
                    final toAccount = _toAccount;

                    if (amount.isEmpty ||
                        description.isEmpty ||
                        (_transactionType == 'own' &&
                            (fromAccount.isEmpty || toAccount == null)) ||
                        (_transactionType == 'other' &&
                            targetAccount.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.fillallfields),
                        ),
                      );
                      return;
                    }

                    final newTransaction = Transaction(
                      account: int.parse(fromAccount),
                      targetAccount: _transactionType == 'other'
                          ? int.parse(targetAccount)
                          : int.parse(toAccount!),
                      cantidad: int.parse(amount),
                      descripcion: description,
                      tipo: 'gasto',
                    );

                    context
                        .read<TransactionBloc>()
                        .add(CreateTransactions(newTransaction));
                  },
                  child: Text(AppLocalizations.of(context)!.buttonconfirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
