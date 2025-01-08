import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/create_transaction_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/get_transactions_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionsEvent, TransactionState> {
  final CreateTransactionUseCase createTransactionUsecase;
  final GetTransactionsUseCase getTransactionsUsecase;

  TransactionBloc(
      {required this.createTransactionUsecase,
      required this.getTransactionsUsecase})
      : super(const TransactionState()) {
    on<GetAllTransactions>((event, emit) async {
      emit(state.copyWith(isLoading: true, transactions: []));

      final result = await getTransactionsUsecase();
      result.fold(
        (error) => emit(state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
            transactions: [])),
        (transactions) {
          final filteredTransactions = transactions.where((transaction) {
            bool matches = true;

            if (event.filters['descripcion'] != null &&
                event.filters['descripcion'].isNotEmpty) {
              matches = matches &&
                  transaction.descripcion == event.filters['descripcion'];
            }

            if (event.filters['tipo'] != null &&
                event.filters['tipo'].isNotEmpty) {
              matches = matches && transaction.tipo == event.filters['tipo'];
            }

            if (event.filters['fecha'] != null &&
                event.filters['fecha'].isNotEmpty) {
              matches = matches &&
                  transaction.created_at!.startsWith(event.filters['fecha']);
            }

            if (event.filters['cantidad'] != null) {
              matches =
                  matches && transaction.cantidad == event.filters['cantidad'];
            }

            return matches;
          }).toList();

          emit(state.copyWith(
              isLoading: false, transactions: filteredTransactions));
        },
      );
    });

    on<CreateTransactions>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await createTransactionUsecase(event.transaction);
      result.fold(
        (error) {
          emit(state.copyWith(
            errorMessage: error.toString(),
            isLoading: false,
          ));
        },
        (transaction) {
          final updatedtransaction = List<Transaction>.from(state.transactions)
            ..add(transaction);

          emit(state.copyWith(
            transactions: updatedtransaction,
            isLoading: false,
          ));
        },
      );
    });
  }
}
