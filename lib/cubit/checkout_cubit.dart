import 'package:fluro_checkout/model/selected_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/models/models.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutState.initial());

  void updateCheckout(
      List<Product> selectedProducts, SpecialPrices specialPrices) {
    List<SelectedProduct> selectedProductsWithAppliedPromotions =
        _calculatePromotions(selectedProducts, specialPrices);
    int totalAmount = _calculateTotal(selectedProductsWithAppliedPromotions);
    emit(CheckoutState(
      selectedProductsWithAppliedPromotions:
          selectedProductsWithAppliedPromotions,
      totalAmount: totalAmount,
    ));
  }

  List<SelectedProduct> _calculatePromotions(
      List<Product> selectedProducts, SpecialPrices specialPrices) {
    Map<String, int> itemCounts = {};

    for (final product in selectedProducts) {
      itemCounts[product.name] = (itemCounts[product.name] ?? 0) + 1;
    }

    List<SelectedProduct> appliedPromotions = [];

    for (final item in itemCounts.keys) {
      int count = itemCounts[item]!;
      int unitPrice = selectedProducts.firstWhere((p) => p.name == item).price;
      appliedPromotions.addAll(
          _applyMultiPricedPromotions(item, count, unitPrice, specialPrices));
    }

    return appliedPromotions;
  }

  List<SelectedProduct> _applyMultiPricedPromotions(
      String item, int count, int unitPrice, SpecialPrices specialPrices) {
    List<SelectedProduct> appliedPromotions = [];
    int remainingCount = count;

    for (MultiPricedPromotion promotion
        in specialPrices.multiPricedPromotions ?? []) {
      if (promotion.productId == item) {
        int promotionPrice = promotion.calculatePrice(count, unitPrice);

        appliedPromotions.add(SelectedProduct(
          name: item,
          oldPrice: unitPrice * count, // Original total price without promotion
          currentPrice: promotionPrice,
          promotionApplied: 'Multi-priced Promotion',
        ));

        remainingCount -= count;
      }
    }

    // For the remaining items without promotion
    for (int i = 0; i < remainingCount; i++) {
      appliedPromotions.add(SelectedProduct(
        name: item,
        oldPrice: null,
        currentPrice: unitPrice,
        promotionApplied: '',
      ));
    }

    return appliedPromotions;
  }

  int _calculateTotal(List<SelectedProduct> appliedPromotions) {
    return appliedPromotions.fold(
        0, (total, promo) => total + promo.currentPrice);
  }
}

// ToDo: Move to separate file
/// Used to calculate the price for a product based on a multi-priced promotion
/// (e.g: buy 3 for a special price).
extension on MultiPricedPromotion {
  int calculatePrice(int itemCount, int unitPrice) {
    final setsOfItems = itemCount ~/ quantity;
    final remainingLeftovers = itemCount % quantity;
    return setsOfItems * specialPrice + remainingLeftovers * unitPrice;
  }
}

// ToDo: Move to separate file
/// Used to calculate an offer in case someone buys a specific amount
/// (e.g: buy 2 get one free).
extension on BuyNGetFreePromotion {
  int calculatePrice(int itemCount, int unitPrice) {
    /// If the number of items select was more the amountNeeded to get an offer
    if (itemCount >= amountNeeded) {
      // Number of sets that qualify for the promotion
      final setsOfItems = itemCount ~/ (amountNeeded + 1);
      // Remaining items that do not belong to a set
      final remainingItems = itemCount % (amountNeeded + 1);
      // Total price for the items including the promotion
      return setsOfItems * amountNeeded * unitPrice +
          remainingItems * unitPrice;
    } else {
      // If there are not enough items to qualify for the promotion, pay the unit price
      return itemCount * unitPrice;
    }
  }
}
