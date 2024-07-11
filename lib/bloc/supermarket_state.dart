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
  final List<Product> selectedProducts;
  final String? errorMessage;

  const SupermarketState({
    required this.status,
    this.products = const [],
    required this.selectedProducts,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, products, selectedProducts, errorMessage];

  SupermarketState copyWith({
    SupermarketStatus? status,
    List<Product>? products,
    List<Product>? selectedProducts,
    String? errorMessage,
  }) {
    return SupermarketState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
