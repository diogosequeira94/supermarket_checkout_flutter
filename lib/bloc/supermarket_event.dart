part of 'supermarket_bloc.dart';

abstract class SupermarketEvent extends Equatable {
  const SupermarketEvent();
}

final class SupermarketLoadStarted extends SupermarketEvent {
  const SupermarketLoadStarted();

  @override
  List<Object?> get props => [];
}
