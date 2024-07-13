import 'package:fluro_checkout/model/selected_product.dart';
import 'package:fluro_checkout/utils/shared_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/models/models.dart';
import '../utils/extensions.dart';

part 'checkout_state.dart';

/// Business Logic Component used to update checkout cart
/// Calculates and applies special prices/promotions
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutState.initial());

  void updateCheckout(
      List<Product> selectedProducts, SpecialPrices specialPrices) {
    List<SelectedProduct> selectedProductsWithAppliedPromotions =
        _calculatePromotions(selectedProducts, specialPrices);

    final totalAmount = _calculateTotal(selectedProductsWithAppliedPromotions);

    emit(CheckoutState(
      selectedProductsWithAppliedPromotions:
          selectedProductsWithAppliedPromotions,
      totalAmount: totalAmount,
    ));
  }

  List<SelectedProduct> _calculatePromotions(
      List<Product> selectedProducts, SpecialPrices specialPrices) {
    Map<String, int> itemCountsMap = {};

    for (final product in selectedProducts) {
      itemCountsMap[product.name] = (itemCountsMap[product.name] ?? 0) + 1;
    }

    List<SelectedProduct> appliedPromotions = [];

    // Apply meal deal promotions first
    if (!specialPrices.mealDealPromotions.isNullOrEmpty) {
      _applyMealDeal(selectedProducts, specialPrices.mealDealPromotions!,
          itemCountsMap, appliedPromotions);
    }

    for (final item in itemCountsMap.keys) {
      int count = itemCountsMap[item]!;
      int unitPrice = selectedProducts.firstWhere((p) => p.name == item).price;

      // Apply multi-priced promotions
      if (!specialPrices.multiPricedPromotions.isNullOrEmpty) {
        for (MultiPricedPromotion promotion
            in specialPrices.multiPricedPromotions!) {
          if (promotion.productId == item && count > 0) {
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
      }

      // Apply buy N get one free promotions
      if (!specialPrices.buyNGetFreePromotions.isNullOrEmpty) {
        for (BuyNGetFreePromotion promotion
            in specialPrices.buyNGetFreePromotions!) {
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

  void _applyMealDeal(
      List<Product> selectedProducts,
      List<MealDealPromotion> mealDealPromotions,
      Map<String, int> itemCountsMap,
      List<SelectedProduct> appliedPromotions) {
    for (MealDealPromotion promotion in mealDealPromotions) {
      // The only meal deal works with two products
      // Can be enhanced to accept N products
      final firstProductId = promotion.productIds[0];
      final secondProductId = promotion.productIds[1];

      // Check if the productsId exist
      if (itemCountsMap.containsKey(firstProductId) &&
          itemCountsMap.containsKey(secondProductId)) {
        final countFirstProduct = itemCountsMap[firstProductId]!;
        final countSecondProduct = itemCountsMap[secondProductId]!;

        final unitPriceFirstProduct =
            selectedProducts.firstWhere((p) => p.name == firstProductId).price;
        final unitPriceSecondProduct =
            selectedProducts.firstWhere((p) => p.name == secondProductId).price;

        // Calculate the remaining items
        final setsOfItems = (countFirstProduct < countSecondProduct)
            ? countFirstProduct
            : countSecondProduct;
        final remainingFirstProducts = countFirstProduct - setsOfItems;
        final remainingSecondProducts = countSecondProduct - setsOfItems;

        // Apply the meal deal promotion using the extension method
        final promotionPrice = promotion.calculatePrice(
          itemCountFirstProduct: countFirstProduct,
          itemCountSecondProduct: countSecondProduct,
          priceFirstProduct: unitPriceFirstProduct,
          priceSecondProduct: unitPriceSecondProduct,
        );

        appliedPromotions.add(SelectedProduct(
          name: '${firstProductId} + ${secondProductId}',
          oldPrice:
              (unitPriceFirstProduct + unitPriceSecondProduct) * setsOfItems,
          currentPrice: promotionPrice,
          promotionApplied: SharedStrings.mealDealPromotion,
        ));

        // Remove the counts that have been applied to meal deal promotion
        itemCountsMap[firstProductId] = remainingFirstProducts;
        itemCountsMap[secondProductId] = remainingSecondProducts;
      }
    }
  }

  void resetCheckout() {
    emit(CheckoutState.initial(checkoutInProgress: true));
  }

  int _calculateTotal(List<SelectedProduct> appliedPromotions) {
    return appliedPromotions.fold(
        0, (total, promo) => total + promo.currentPrice);
  }
}
