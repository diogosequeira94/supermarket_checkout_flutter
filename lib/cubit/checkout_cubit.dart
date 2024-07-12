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

    // Apply meal deal promotions first
    if (!specialPrices.mealDealPromotions.isNullOrEmpty) {
      _applyMealDeal(selectedProducts, specialPrices.mealDealPromotions!,
          itemCounts, appliedPromotions);
    }

    for (final item in itemCounts.keys) {
      int count = itemCounts[item]!;
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
      Map<String, int> itemCounts,
      List<SelectedProduct> appliedPromotions) {
    for (MealDealPromotion promotion in mealDealPromotions) {
      String productIdD = promotion.productIds[0];
      String productIdE = promotion.productIds[1];

      if (itemCounts.containsKey(productIdD) &&
          itemCounts.containsKey(productIdE)) {
        int countD = itemCounts[productIdD]!;
        int countE = itemCounts[productIdE]!;
        int unitPriceD =
            selectedProducts.firstWhere((p) => p.name == productIdD).price;
        int unitPriceE =
            selectedProducts.firstWhere((p) => p.name == productIdE).price;

        // Calculate the remaining items
        int setsOfItems = (countD < countE) ? countD : countE;
        int remainingItemsD = countD - setsOfItems;
        int remainingItemsE = countE - setsOfItems;

        // Apply the meal deal promotion using the extension method
        int promotionPrice = promotion.calculatePrice(
          itemCountFirstProduct: countD,
          itemCountSecondProduct: countE,
          priceFirstProduct: unitPriceD,
          priceSecondProduct: unitPriceE,
        );

        appliedPromotions.add(SelectedProduct(
          name: '${productIdD} + ${productIdE}',
          oldPrice: (unitPriceD + unitPriceE) * setsOfItems,
          currentPrice: promotionPrice,
          promotionApplied: SharedStrings.mealDealPromotion,
        ));

        // Remove the counts that have been applied to meal deal promotion
        itemCounts[productIdD] = remainingItemsD;
        itemCounts[productIdE] = remainingItemsE;
      }
    }
  }

  int _calculateTotal(List<SelectedProduct> appliedPromotions) {
    return appliedPromotions.fold(
        0, (total, promo) => total + promo.currentPrice);
  }
}
