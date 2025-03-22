import 'package:flutter_bank_app/Domain/Usecases/Investments/create_investments_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Investments/get_all_investments_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvestmentsBloc extends Bloc<InvestmentsEvent, InvestmentsState> {
  final GetInvestmentsUseCase getInvestmentsUseCase;
  final CreateInvestmentUseCase createInvestmentUseCase;

  InvestmentsBloc({
    required this.getInvestmentsUseCase,
    required this.createInvestmentUseCase,
  }) : super(const InvestmentsState()) {
    on<GetAllInvestments>((event, emit) async {
      emit(state.copyWith(isLoading: true, investments: []));

      final result = await getInvestmentsUseCase(event.accountid);
      result.fold(
        (error) => emit(state.copyWith(
            isLoading: false, errorMessage: error.toString(), investments: [])),
        (investments) {
          emit(state.copyWith(isLoading: false, investments: investments));
        },
      );
    });

    on<CreateInvestment>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await createInvestmentUseCase(
          event.symbol, event.amount, event.accountId);
      result.fold(
        (error) {
          emit(state.copyWith(
            errorMessage: error.toString(),
            isLoading: false,
          ));
        },
        (investments) {
          emit(state.copyWith(
            isLoading: false,
          ));
        },
      );
    });
  }
}
