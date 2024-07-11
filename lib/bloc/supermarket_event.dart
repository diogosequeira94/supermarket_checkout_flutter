part of 'supermarket_bloc.dart';

abstract class SupermarketEvent extends Equatable {
  const SupermarketEvent();
}

final class SupermarketLoadStarted extends SupermarketEvent {
  const SupermarketLoadStarted();

  @override
  List<Object?> get props => [];
}

final class SupermarketAddProduct extends SupermarketEvent {
  final Product product;
  const SupermarketAddProduct({required this.product});

  @override
  List<Object?> get props => [product];
}

final class SupermarketRemoveProduct extends SupermarketEvent {
  final Product product;
  const SupermarketRemoveProduct({required this.product});

  @override
  List<Object?> get props => [product];
}
