import 'package:equatable/equatable.dart';

// Eventos
abstract class TradingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllTrading extends TradingEvent {
  GetAllTrading();
}

class GetRecordTrading extends TradingEvent {
  final String name;
  GetRecordTrading({required this.name});
}
