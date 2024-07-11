part of 'supermarket_bloc.dart';

enum ProductOperation {
  add,
  remove,
}

abstract class SupermarketEvent extends Equatable {
  const SupermarketEvent();
}

final class SupermarketLoadStarted extends SupermarketEvent {
  const SupermarketLoadStarted();

  @override
  List<Object?> get props => [];
}

final class SupermarketProductOperationPressed extends SupermarketEvent {
  final ProductOperation operation;
  final Product product;
  const SupermarketProductOperationPressed({
    required this.operation,
    required this.product,
  });

  @override
  List<Object?> get props => [operation, product];
}
