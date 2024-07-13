part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  final List<SelectedProduct> selectedProductsWithAppliedPromotions;
  final int totalAmount;
  final bool checkoutInProgress;

  const CheckoutState({
    required this.selectedProductsWithAppliedPromotions,
    required this.totalAmount,
    this.checkoutInProgress = false,
  });

  factory CheckoutState.initial({bool checkoutInProgress = false}) {
    return CheckoutState(
      selectedProductsWithAppliedPromotions: const [],
      totalAmount: 0,
      checkoutInProgress: checkoutInProgress,
    );
  }

  @override
  List<Object?> get props => [
        selectedProductsWithAppliedPromotions,
        totalAmount,
        checkoutInProgress,
      ];
}
