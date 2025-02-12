import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/Domain/Usecases/Credit%20Card/create_creditCard_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Credit%20Card/delete_creditCard_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Credit%20Card/get_all_creditCard_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreditCardBloc extends Bloc<CreditCardEvent, CreditCardState> {
  final CreateCreditCardUseCase createCreditCardUseCase;
  final GetAllCreditCardsUseCase getAllCreditCardsUseCase;
  final DeleteCreditCardUseCase deleteCreditCardUseCase;

  CreditCardBloc({
    required this.createCreditCardUseCase,
    required this.getAllCreditCardsUseCase,
    required this.deleteCreditCardUseCase,
  }) : super(const CreditCardState()) {
    on<GetAllCreditCards>((event, emit) async {
      emit(state.copyWith(isLoading: true, creditCards: []));

      final result = await getAllCreditCardsUseCase();
      result.fold(
        (error) => emit(state.copyWith(
            isLoading: false, errorMessage: error.toString(), creditCards: [])),
        (creditCards) {
          emit(state.copyWith(isLoading: false, creditCards: creditCards));
        },
      );
    });

    on<CreateCreditCard>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await createCreditCardUseCase(event.creditCard);
      result.fold(
        (error) {
          emit(state.copyWith(
            errorMessage: error.toString(),
            isLoading: false,
          ));
        },
        (success) {
          final updatedCreditCards =
              List<CreditCardEntity>.from(state.creditCards)
                ..add(event.creditCard);
          emit(state.copyWith(
            creditCards: updatedCreditCards,
            isLoading: false,
          ));
        },
      );
    });

    on<DeleteCreditCardEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await deleteCreditCardUseCase(event.id);
      result.fold(
        (error) {
          emit(state.copyWith(
            errorMessage: error.toString(),
            isLoading: false,
          ));
        },
        (_) {
          final updatedCreditCards = state.creditCards.where((card) {
            return card.id_tarjeta != event.id;
          }).toList();
          emit(state.copyWith(
              creditCards: updatedCreditCards, isLoading: false));
        },
      );
    });
  }
}
