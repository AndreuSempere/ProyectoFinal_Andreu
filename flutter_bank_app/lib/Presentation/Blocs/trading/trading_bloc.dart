import 'package:flutter_bank_app/Domain/Usecases/Trading/get_all_trading_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final GetAllTradingUseCase getTradingUsecase;

  TradingBloc({
    required this.getTradingUsecase,
  }) : super(const TradingState()) {
    on<GetAllTrading>((event, emit) async {
      emit(state.copyWith(isLoading: true, tradings: []));

      final result = await getTradingUsecase();
      result.fold(
        (error) => emit(state.copyWith(
            isLoading: false, errorMessage: error.toString(), tradings: [])),
        (tradings) {
          emit(state.copyWith(isLoading: false, tradings: tradings));
        },
      );
    });
  }
}
