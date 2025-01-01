import 'package:flutter/material.dart';

class CardModel {
  List<CardResults> results;

  CardModel({required this.results});

  CardModel.fromJson(Map<String, dynamic> json) : results = [] {
    if (json['cardResults'] != null) {
      json['cardResults'].forEach((v) {
        results.add(CardResults.fromJson(v));
      });
    }
  }
}

class CardResults {
  String cardHolderName;
  String cardNumber;
  String cardMonth;
  String cardYear;
  String cardCvv;
  Color cardColor;
  String cardType;

  CardResults({
    required this.cardHolderName,
    required this.cardNumber,
    required this.cardMonth,
    required this.cardYear,
    required this.cardCvv,
    required this.cardColor,
    required this.cardType,
  });

  CardResults.fromJson(Map<String, dynamic> json)
      : cardHolderName = json['cardHolderName'] ?? '',
        cardNumber = json['cardNumber'] ?? '',
        cardMonth = json['cardMonth'] ?? '',
        cardYear = json['cardYear'] ?? '',
        cardCvv = json['cardCvv'] ?? '',
        cardColor = _parseColor(json['cardColor']),
        cardType = json['cardType'] ?? 'VISA';

  static Color _parseColor(dynamic colorValue) {
    if (colorValue is int) {
      return Color(colorValue);
    }
    return Colors.blue;
  }
}
