part of 'supermarket_bloc.dart';

enum SupermarketStatus {
  initial,
  loading,
  loaded,
  error,
}

class SupermarketState extends Equatable {
  final SupermarketStatus status;
  final List<Product>? products;
  final String? errorMessage;

  const SupermarketState({
    required this.status,
    this.products = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, products, errorMessage];

  SupermarketState copyWith({
    SupermarketStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return SupermarketState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
