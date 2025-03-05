import 'package:equatable/equatable.dart';

// Eventos
abstract class TradingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllTrading extends TradingEvent {
  GetAllTrading();
}
