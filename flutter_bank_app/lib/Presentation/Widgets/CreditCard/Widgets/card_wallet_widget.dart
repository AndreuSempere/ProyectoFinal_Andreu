import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    rotateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: opacityController, curve: Curves.fastOutSlowIn);

    animation = Tween(begin: -2.0, end: -3.15).animate(rotateController);
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

    rotateController.forward();
    opacityController.forward();
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

          return Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: AnimatedBuilder(
                    animation: animation,
                    child: SizedBox(
                      width: screenSize.width / 1.6,
                      height: screenSize.height / 2.2,
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
                const SizedBox(height: 150.0),
                const CircularProgressIndicator(
                  strokeWidth: 6.0,
                  backgroundColor: Colors.lightBlue,
                ),
                const SizedBox(height: 30.0),
                FadeTransition(
                  opacity: opacityAnimation,
                  child: const Text(
                    'Tarjeta Añadida',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
