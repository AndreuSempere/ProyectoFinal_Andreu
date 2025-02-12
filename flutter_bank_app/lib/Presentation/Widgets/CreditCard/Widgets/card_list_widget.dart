import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_front_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_back_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/flip_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<CreditCardBloc, CreditCardState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        } else if (state.creditCards.isEmpty) {
          return const Center(child: Text('No cards available'));
        }

        return SizedBox(
          height: screenSize.height * 0.8,
          child: ListView.builder(
            itemCount: state.creditCards.length,
            itemBuilder: (context, index) {
              final card = state.creditCards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: FlipCard(
                  key: GlobalKey<FlipCardState>(),
                  front: CardFront(card: card),
                  back: CardBack(
                    cardColor: card.cardColor!,
                    cardCvv: card.cardCvv!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
