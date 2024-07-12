import 'package:flutter_test/flutter_test.dart';
import 'package:fluro_checkout/utils/extensions.dart';

import '../unit_test_helpers.dart';

void main() {
  group('MultiPricedPromotion', () {
    test('Should apply a promotion when buying 3 items', () {
      expect(multiPricePromotion.calculatePrice(3, 50), 120);
    });

    test('Should display full price when buying less than necessary quantity',
        () {
      expect(multiPricePromotion.calculatePrice(2, 50), 100);
    });

    test('Should apply promotion + full price on leftover price', () {
      expect(multiPricePromotion.calculatePrice(4, 50), 170);
    });

    test('Should apply promotion when there is more than 1 set', () {
      expect(multiPricePromotion.calculatePrice(6, 50), 240);
    });

    test(
        'Should apply promotion + full price on leftover price when there is more than 1 set',
        () {
      expect(multiPricePromotion.calculatePrice(7, 50), 290);
    });
  });

  group('BuyNGetFree', () {
    test('Should apply a promotion after amountNeeded is met', () {
      expect(buyNGetFreePromotion.calculatePrice(5, 50), 200);
    });

    test('Should still show the same price if its the same as amountNeeded',
        () {
      expect(buyNGetFreePromotion.calculatePrice(4, 50), 200);
    });

    test('Should apply the promotion and calculate the surpluses', () {
      expect(buyNGetFreePromotion.calculatePrice(6, 50), 250);
    });

    test(
        'Should apply the promotion when there are more than 1 set calculate the surpluses',
        () {
      expect(buyNGetFreePromotion.calculatePrice(9, 50), 400);
    });
  });

  group('MealDealPromotion', () {
    test('Should apply the meal deal promotion correctly', () {
      expect(
          mealDealPromotion.calculatePrice(
            itemCountFirstProduct: 1,
            itemCountSecondProduct: 1,
            priceFirstProduct: 200,
            priceSecondProduct: 200,
          ),
          300);
    });

    test(
        'Should apply the meal deal promotion and charge full price for surplus items',
        () {
      expect(
          mealDealPromotion.calculatePrice(
            itemCountFirstProduct: 2,
            itemCountSecondProduct: 1,
            priceFirstProduct: 200,
            priceSecondProduct: 200,
          ),
          500);
    });

    test('Should charge full price when no promotion can be applied', () {
      expect(
          mealDealPromotion.calculatePrice(
            itemCountFirstProduct: 1,
            itemCountSecondProduct: 0,
            priceFirstProduct: 200,
            priceSecondProduct: 200,
          ),
          200);
    });

    test('Should apply promotion when there are multiple sets', () {
      expect(
          mealDealPromotion.calculatePrice(
            itemCountFirstProduct: 3,
            itemCountSecondProduct: 3,
            priceFirstProduct: 200,
            priceSecondProduct: 200,
          ),
          900);
    });

    test(
        'Should apply promotion and charge full price for surplus items with multiple sets',
        () {
      expect(
          mealDealPromotion.calculatePrice(
            itemCountFirstProduct: 4,
            itemCountSecondProduct: 3,
            priceFirstProduct: 200,
            priceSecondProduct: 200,
          ),
          1100);
    });
  });
}
