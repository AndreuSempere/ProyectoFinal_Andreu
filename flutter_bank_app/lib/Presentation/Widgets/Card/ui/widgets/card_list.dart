import 'package:flutter/material.dart';
import '../../models/card_model.dart';
import '../../../../Blocs/card/card_list_bloc.dart';
import '../widgets/card_chip.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return StreamBuilder<List<CardResults>>(
      stream: cardListBloc.cardList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cards = snapshot.data!;
        if (cards.isEmpty) {
          return const Center(child: Text('No cards available'));
        }

        return SizedBox(
          height: screenSize.height * 0.8,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return CardFrontList(
                cardModel: cards[index],
              );
            },
            itemCount: cards.length,
            itemWidth: screenSize.width * 0.7,
            itemHeight: screenSize.height * 0.52,
            layout: SwiperLayout.STACK,
            scrollDirection: Axis.vertical,
          ),
        );
      },
    );
  }
}

class CardFrontList extends StatelessWidget {
  final CardResults cardModel;
  const CardFrontList({super.key, required this.cardModel});

  @override
  Widget build(BuildContext context) {
    final cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 25.0, right: 52.0),
          child: Image(
            image: AssetImage('assets/credit_card/visa_logo.png'),
            width: 65.0,
            height: 32.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 52.0),
          child: Text(
            cardModel.cardType,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );

    final cardNumber = Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildDots(),
        ],
      ),
    );

    final cardLastNumber = Padding(
      padding: const EdgeInsets.only(top: 1.0, left: 55.0),
      child: Text(
        cardModel.cardNumber.substring(12),
        style: const TextStyle(color: Colors.white, fontSize: 8.0),
      ),
    );

    final cardValidThru = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Column(
              children: <Widget>[
                Text(
                  'valid',
                  style: TextStyle(color: Colors.white, fontSize: 8.0),
                ),
                Text(
                  'thru',
                  style: TextStyle(color: Colors.white, fontSize: 8.0),
                ),
              ],
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              '${cardModel.cardMonth}/${cardModel.cardYear.substring(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ));

    final cardOwner = Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 50.0),
      child: Text(
        cardModel.cardHolderName,
        style: const TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    );

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: cardModel.cardColor,
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              cardLogo,
              const CardChip(),
              cardNumber,
              cardLastNumber,
              cardValidThru,
              cardOwner,
            ],
          ),
        ));
  }

  Widget _buildDots() {
    final List<Widget> dotList = [];
    var counter = 0;
    for (var i = 0; i < 12; i++) {
      counter += 1;
      dotList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Container(
            width: 6.0,
            height: 6.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
      if (counter == 4) {
        counter = 0;
        dotList.add(const SizedBox(width: 60.0));
      }
    }
    dotList.add(_buildNumbers());
    return Row(children: dotList);
  }

  Widget _buildNumbers() {
    return Text(
      cardModel.cardNumber.substring(12),
      style: const TextStyle(color: Colors.white),
    );
  }
}
