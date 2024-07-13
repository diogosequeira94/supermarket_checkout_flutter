import 'package:bloc_test/bloc_test.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/model/selected_product.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:fluro_checkout/utils/shared_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../unit_test_helpers.dart';

// Mock classes or helper functions if needed
class MockSupermarketRepository extends Mock implements SupermarketRepository {}

void main() {
  late CheckoutCubit checkoutCubit;

  setUp(() {
    checkoutCubit = CheckoutCubit();
  });

  tearDown(() {
    checkoutCubit.close();
  });

  group('CheckoutCubit', () {
    group('UpdateCheckout - multiPricePromotion', () {
      final multiPricedProductsMock = [
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'B', price: 10, imageId: 'mockImageIdB'),
      ];

      blocTest<CheckoutCubit, CheckoutState>(
        'emits [CheckoutState] correctly after applying a multiPricePromotion',
        setUp: () {},
        build: () => checkoutCubit,
        act: (cubit) {
          const specialPrices = SpecialPrices(
            multiPricedPromotions: [multiPricePromotion],
            buyNGetFreePromotions: null,
            mealDealPromotions: null,
          );

          cubit.updateCheckout(
            multiPricedProductsMock,
            specialPrices,
          );
        },
        expect: () => [
          const CheckoutState(
            selectedProductsWithAppliedPromotions: [
              SelectedProduct(
                name: 'A',
                currentPrice: 120,
                oldPrice: 150,
                promotionApplied: SharedStrings.multiPricedPromotion,
              ),
              SelectedProduct(
                name: 'B',
                currentPrice: 10,
                oldPrice: null,
                promotionApplied: '',
              ),
            ],
            totalAmount: 130,
          ),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits [CheckoutState] correctly after applying a double multiPricePromotion',
        setUp: () {},
        build: () => checkoutCubit,
        act: (cubit) {
          const specialPrices = SpecialPrices(
            multiPricedPromotions: [multiPricePromotion],
            buyNGetFreePromotions: null,
            mealDealPromotions: null,
          );

          cubit.updateCheckout(
            [...multiPricedProductsMock, ...multiPricedProductsMock],
            specialPrices,
          );
        },
        expect: () => [
          const CheckoutState(
            selectedProductsWithAppliedPromotions: [
              SelectedProduct(
                name: 'A',
                currentPrice: 240,
                oldPrice: 300,
                promotionApplied: SharedStrings.multiPricedPromotion,
              ),
              SelectedProduct(
                name: 'B',
                currentPrice: 20,
                oldPrice: null,
                promotionApplied: '',
              ),
            ],
            totalAmount: 260,
          ),
        ],
      );
    });

    group('UpdateCheckout - buyNGetFree', () {
      final buyNGetFreeProductsMock = [
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
        const Product(name: 'A', price: 50, imageId: 'mockImageIdA'),
      ];
      blocTest<CheckoutCubit, CheckoutState>(
        'emits [CheckoutState] correctly after applying a buyNGetFree',
        setUp: () {},
        build: () => checkoutCubit,
        act: (cubit) {
          const specialPrices = SpecialPrices(
            multiPricedPromotions: null,
            buyNGetFreePromotions: [buyNGetFreePromotion],
            mealDealPromotions: null,
          );

          cubit.updateCheckout(
            buyNGetFreeProductsMock,
            specialPrices,
          );
        },
        expect: () => [
          const CheckoutState(
            selectedProductsWithAppliedPromotions: [
              SelectedProduct(
                name: 'A',
                currentPrice: 200,
                oldPrice: 250,
                promotionApplied: SharedStrings.buyNGetFree,
              ),
            ],
            totalAmount: 200,
          ),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits [CheckoutState] correctly after applying a double buyNGetFree',
        setUp: () {},
        build: () => checkoutCubit,
        act: (cubit) {
          const specialPrices = SpecialPrices(
            multiPricedPromotions: null,
            buyNGetFreePromotions: [buyNGetFreePromotion],
            mealDealPromotions: null,
          );

          cubit.updateCheckout(
            [...buyNGetFreeProductsMock, ...buyNGetFreeProductsMock],
            specialPrices,
          );
        },
        expect: () => [
          const CheckoutState(
            selectedProductsWithAppliedPromotions: [
              SelectedProduct(
                name: 'A',
                currentPrice: 400,
                oldPrice: 500,
                promotionApplied: SharedStrings.buyNGetFree,
              ),
            ],
            totalAmount: 400,
          ),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits [CheckoutState.initial] with [checkoutInProgress] when calling [resetCheckout()]',
        setUp: () {},
        build: () => checkoutCubit,
        act: (cubit) {
          cubit.resetCheckout();
        },
        expect: () => [
          CheckoutState.initial(
            checkoutInProgress: true,
          ),
        ],
      );
    });
  });
}
