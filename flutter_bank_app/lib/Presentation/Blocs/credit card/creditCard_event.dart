import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';

abstract class CreditCardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateCreditCard extends CreditCardEvent {
  final CreditCardEntity creditCard;

  CreateCreditCard(this.creditCard);
}

class GetAllCreditCards extends CreditCardEvent {}

class DeleteCreditCardEvent extends CreditCardEvent {
  final int id;
  DeleteCreditCardEvent({required this.id});
}
