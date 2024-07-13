part of 'supermarket_bloc.dart';

abstract class SupermarketEvent extends Equatable {
  const SupermarketEvent();
}

final class SupermarketLoadStarted extends SupermarketEvent {
  const SupermarketLoadStarted();

  @override
  List<Object?> get props => [];
}

final class SupermarketSelectProductPressed extends SupermarketEvent {
  final Product product;
  const SupermarketSelectProductPressed({
    required this.product,
  });

  @override
  List<Object?> get props => [product];
}

final class SupermarketProductRemoveSelectedPressed extends SupermarketEvent {
  final String selectedProductName;
  const SupermarketProductRemoveSelectedPressed({
    required this.selectedProductName,
  });

  @override
  List<Object?> get props => [selectedProductName];
}

final class SupermarketFinishShopPressed extends SupermarketEvent {
  const SupermarketFinishShopPressed();

  @override
  List<Object?> get props => [];
}
