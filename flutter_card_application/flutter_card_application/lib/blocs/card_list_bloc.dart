import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/card_model.dart';
import 'dart:convert';
import '../helpers/card_colors.dart';

class CardListBloc {
  final _cardsCollection = BehaviorSubject<List<CardResults>>();
  late List<CardResults> _cardResults;

  //Retrieve data from Stream
  Stream<List<CardResults>> get cardList => _cardsCollection.stream;

  void initialData() async {
    try {
      var initialData = await rootBundle.loadString('data/initialData.json');
      var decodedJson = jsonDecode(initialData);
      _cardResults = CardModel.fromJson(decodedJson).results;
      for (var i = 0; i < _cardResults.length; i++) {
        _cardResults[i].cardColor = CardColor.baseColors[i % CardColor.baseColors.length];
      }
      _cardsCollection.sink.add(_cardResults);
    } catch (e) {
      _cardsCollection.addError('Failed to load card data: $e');
    }
  }

  CardListBloc(){
    initialData();
  }

  void addCardToList(CardResults newCard){
    _cardResults.add(newCard);
    _cardsCollection.sink.add(_cardResults);
  }

  void dispose() {
    _cardsCollection.close();
  }
}

final cardListBloc = CardListBloc();