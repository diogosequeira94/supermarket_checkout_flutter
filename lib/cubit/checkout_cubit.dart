import 'package:fluro_checkout/model/selected_product.dart';
import 'package:fluro_checkout/utils/shared_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/models/models.dart';
import '../utils/extensions.dart';

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

      // Apply multi-priced promotions
      for (MultiPricedPromotion promotion
          in specialPrices.multiPricedPromotions ?? []) {
        if (promotion.productId == item) {
          int promotionPrice = promotion.calculatePrice(count, unitPrice);
          appliedPromotions.add(SelectedProduct(
            name: item,
            oldPrice: unitPrice * count,
            currentPrice: promotionPrice,
            promotionApplied: SharedStrings.multiPricedPromotion,
          ));
          count = 0;
        }
      }

      // Apply buy N get one free promotions
      for (BuyNGetFreePromotion promotion
          in specialPrices.buyNGetFreePromotions ?? []) {
        if (promotion.productId == item && count > 0) {
          int promotionPrice = promotion.calculatePrice(count, unitPrice);
          appliedPromotions.add(SelectedProduct(
            name: item,
            oldPrice: unitPrice * count,
            currentPrice: promotionPrice,
            promotionApplied: SharedStrings.buyNGetFree,
          ));
          count = 0;
        }
      }

      // For the remaining items without promotion
      if (count > 0) {
        appliedPromotions.add(SelectedProduct(
          name: item,
          oldPrice: null,
          currentPrice: unitPrice * count,
          promotionApplied: '',
        ));
      }
    }

    return appliedPromotions;
  }

  int _calculateTotal(List<SelectedProduct> appliedPromotions) {
    return appliedPromotions.fold(
        0, (total, promo) => total + promo.currentPrice);
  }
}
