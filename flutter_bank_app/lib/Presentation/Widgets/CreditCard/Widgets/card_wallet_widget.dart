import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/CrearCard/Style/my_appbar.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_front_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';

class CardWallet extends StatefulWidget {
  const CardWallet({super.key});

  @override
  _CardWallet createState() => _CardWallet();
}

class _CardWallet extends State<CardWallet> with TickerProviderStateMixin {
  late AnimationController rotateController;
  late AnimationController opacityController;
  late Animation<double> animation;
  late Animation<double> opacityAnimation;
  bool _showSuccessMessage = true;

  @override
  void initState() {
    super.initState();
    // Trigger loading of all credit cards
    context.read<CreditCardBloc>().add(GetAllCreditCards());

    rotateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: opacityController, curve: Curves.fastOutSlowIn);

    animation = Tween(begin: -0.05, end: 0.05).animate(rotateController);
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

    rotateController.forward();
    opacityController.forward();

    // Hide success message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSuccessMessage = false;
        });
      }
    });
  }

  @override
  dispose() {
    rotateController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        appBarTitle: 'Wallet',
        leadingIcon: Icons.arrow_back,
        context: context,
      ),
      body: BlocBuilder<CreditCardBloc, CreditCardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage.isNotEmpty) {
            return Center(child: Text(state.errorMessage));
          } else if (state.creditCards.isEmpty) {
            return const Center(child: Text('No cards available'));
          }

          final CreditCardEntity lastCard = state.creditCards.last;

          return Stack(
            children: [
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: AnimatedBuilder(
                        animation: animation,
                        child: SizedBox(
                          width: screenSize.width * 0.85,
                          height: screenSize.height * 0.25,
                          child: CardFront(card: lastCard),
                        ),
                        builder: (context, widget) {
                          return Transform.rotate(
                            angle: animation.value,
                            child: widget,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    if (_showSuccessMessage)
                      FadeTransition(
                        opacity: opacityAnimation,
                        child: const Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tarjeta Añadida',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (state.creditCards.length > 1)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Otras tarjetas:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.creditCards.length - 1,
                                  itemBuilder: (context, index) {
                                    final card = state.creditCards[index];
                                    return Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ListTile(
                                        leading: const Icon(Icons.credit_card),
                                        title: Text(
                                          'Tarjeta **** ${card.numero_tarjeta.substring(card.numero_tarjeta.length - 4)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(card.cardHolderName),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
