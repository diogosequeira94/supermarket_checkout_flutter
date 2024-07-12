part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  final List<SelectedProduct> selectedProductsWithAppliedPromotions;
  final int totalAmount;

  const CheckoutState({
    required this.selectedProductsWithAppliedPromotions,
    required this.totalAmount,
  });

  factory CheckoutState.initial() {
    return const CheckoutState(selectedProductsWithAppliedPromotions: [], totalAmount: 0);
  }

  @override
  List<Object?> get props => [selectedProductsWithAppliedPromotions, totalAmount];
}