import 'package:bloc_test/bloc_test.dart';
import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock_classes.dart';
import '../unit_test_helpers.dart';

void main() {
  late SupermarketRepository supermarketRepository;
  late SupermarketBloc supermarketBloc;
  late CheckoutCubit checkoutCubit;

  setUp(() {
    supermarketRepository = MockSupermarketRepository();
    checkoutCubit = MockCheckoutCubit();
    supermarketBloc = SupermarketBloc(
      supermarketRepository: supermarketRepository,
      checkoutCubit: checkoutCubit,
    );
  });

  tearDown(() {
    supermarketBloc.close();
  });

  group('SupermarketBloc', () {
    final products = [
      const Product(name: 'A', price: 25, imageId: 'mockImageIdA'),
      const Product(name: 'B', price: 35, imageId: 'mockImageIdB'),
      const Product(name: 'C', price: 15, imageId: 'mockImageIdC'),
      const Product(name: 'D', price: 55, imageId: 'mockImageIdD'),
    ];
    const specialPrices = SpecialPrices(
      multiPricedPromotions: null,
      mealDealPromotions: null,
      buyNGetFreePromotions: null,
    );
    final preloadInformation = SupermarketInfoResponse(
        products: products, specialPrices: specialPrices);

    group('SupermarketLoadStarted', () {
      blocTest<SupermarketBloc, SupermarketState>(
        'emits [SupermarketStatus.loading] and [SupermarketStatus.loaded]',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
        },
        build: () => supermarketBloc,
        act: (bloc) => bloc.add(const SupermarketLoadStarted()),
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'emits [SupermarketStatus.loading] and [SupermarketStatus.error] when there is a SupermarketUnauthorizedException',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo()).thenAnswer(
              (_) async => Future.error(SupermarketUnauthorizedException()));
        },
        build: () => supermarketBloc,
        act: (bloc) => bloc.add(const SupermarketLoadStarted()),
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          const SupermarketState(
            status: SupermarketStatus.error,
            selectedProducts: [],
            errorMessage: 'Ooops, unauthorized exception occurred!',
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'emits [SupermarketStatus.loading] and [SupermarketStatus.error] when there is a SupermarketServiceNotAvailableException',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo()).thenAnswer(
              (_) async => Future.error(
                  SupermarketServiceNotAvailableException(statusCode: 503)));
        },
        build: () => supermarketBloc,
        act: (bloc) => bloc.add(const SupermarketLoadStarted()),
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          const SupermarketState(
            status: SupermarketStatus.error,
            selectedProducts: [],
            errorMessage: 'Ooops, service seems to be down!',
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'emits [SupermarketStatus.loading] and [SupermarketStatus.error] when there is an SupermarketUnauthorizedException',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo()).thenAnswer(
              (_) async => Future.error(
                  SupermarketUnknownErrorException(statusCode: 600)));
        },
        build: () => supermarketBloc,
        act: (bloc) => bloc.add(const SupermarketLoadStarted()),
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          const SupermarketState(
            status: SupermarketStatus.error,
            selectedProducts: [],
            errorMessage: 'Ooops, something went wrong, please try again!',
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'should add product to list when [SupermarketSelectProductPressed] is added and delegates to CheckoutCubit',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
        },
        build: () => supermarketBloc,
        act: (bloc) {
          bloc.add(const SupermarketLoadStarted());
          bloc.add(SupermarketSelectProductPressed(
              product: preloadInformation.products[0]));
        },
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: [preloadInformation.products[0]],
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
          verify(() => checkoutCubit.updateCheckout(
              [preloadInformation.products[0]], specialPrices)).called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'should remove product to list when [SupermarketProductRemoveSelectedPressed] is added and delegates to CheckoutCubit',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
        },
        build: () => supermarketBloc,
        act: (bloc) {
          bloc.add(const SupermarketLoadStarted());
          bloc.add(SupermarketSelectProductPressed(
              product: preloadInformation.products[0]));
          bloc.add(const SupermarketProductRemoveSelectedPressed(
              selectedProductName: 'A'));
        },
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: [preloadInformation.products[0]],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
          verify(() => checkoutCubit.updateCheckout([], specialPrices))
              .called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'should only remove one product to list when [SupermarketProductRemoveSelectedPressed] is added',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
        },
        build: () => supermarketBloc,
        act: (bloc) {
          bloc.add(const SupermarketLoadStarted());
          bloc.add(SupermarketSelectProductPressed(
              product: preloadInformation.products[0]));
          bloc.add(SupermarketSelectProductPressed(
              product: preloadInformation.products[0]));
          bloc.add(const SupermarketProductRemoveSelectedPressed(
              selectedProductName: 'A'));
        },
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: [preloadInformation.products[0]],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: [
              preloadInformation.products[0],
              preloadInformation.products[0],
            ],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: [preloadInformation.products[0]],
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
        },
      );
    });

    group('SupermarketFinishShopPressed', () {
      const updatedSpecialPrices = SpecialPrices(
          multiPricedPromotions: null,
          buyNGetFreePromotions: null,
          mealDealPromotions: [mealDealPromotion]);

      blocTest<SupermarketBloc, SupermarketState>(
        'should return same products and updated promotions when [SupermarketFinishShopPressed] is added',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
          when(() => supermarketRepository.getSpecialPrices())
              .thenAnswer((_) async => updatedSpecialPrices);
        },
        build: () => supermarketBloc,
        act: (bloc) async {
          bloc.add(const SupermarketLoadStarted());
          await Future.delayed(const Duration(milliseconds: 100));
          expect(bloc.specialPrices, preloadInformation.specialPrices);

          bloc.add(const SupermarketFinishShopPressed());
          await Future.delayed(const Duration(milliseconds: 100));
          expect(bloc.specialPrices, updatedSpecialPrices);
        },
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.loading,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
          verify(() => supermarketRepository.getSpecialPrices()).called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'should throw error when getting an Exception after [SupermarketFinishShopPressed] is added',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
          when(() => supermarketRepository.getSpecialPrices()).thenAnswer(
              (_) async => Future.error(
                  SupermarketUnknownErrorException(statusCode: 600)));
        },
        build: () => supermarketBloc,
        act: (bloc) {
          bloc.add(const SupermarketLoadStarted());
          bloc.add(const SupermarketFinishShopPressed());
        },
        expect: () => [
          const SupermarketState(
            status: SupermarketStatus.loading,
            selectedProducts: [],
          ),
          SupermarketState(
            status: SupermarketStatus.loaded,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.loading,
            products: preloadInformation.products,
            selectedProducts: const [],
          ),
          SupermarketState(
            status: SupermarketStatus.error,
            products: preloadInformation.products,
            selectedProducts: const [],
            errorMessage: 'Ooops, something went wrong, please try again!',
          ),
        ],
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
          verify(() => supermarketRepository.getSpecialPrices()).called(1);
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'should call [resetCheckout] on [CheckoutCubit] when [SupermarketFinishShopPressed] is added',
        setUp: () {
          when(() => supermarketRepository.preloadSupermarketInfo())
              .thenAnswer((_) async => preloadInformation);
          when(() => supermarketRepository.getSpecialPrices())
              .thenAnswer((_) async => updatedSpecialPrices);
        },
        build: () => supermarketBloc,
        act: (bloc) {
          bloc.add(const SupermarketLoadStarted());
          bloc.add(const SupermarketFinishShopPressed());
        },
        verify: (_) {
          verify(() => supermarketRepository.preloadSupermarketInfo())
              .called(1);
          verify(() => supermarketRepository.getSpecialPrices()).called(1);
          verify(() => checkoutCubit.resetCheckout(fromCheckout: true))
              .called(1);
        },
      );
    });
  });
}
