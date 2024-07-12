import 'package:bloc_test/bloc_test.dart';
import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSupermarketRepository extends Mock implements SupermarketRepository {}

void main() {
  late SupermarketRepository supermarketRepository;
  late SupermarketBloc supermarketBloc;
  late CheckoutCubit checkoutCubit;

  setUp(() {
    supermarketRepository = MockSupermarketRepository();
    checkoutCubit = CheckoutCubit();
    supermarketBloc = SupermarketBloc(
      supermarketRepository: supermarketRepository,
      checkoutCubit: checkoutCubit,
    );
  });

  tearDown(() {
    supermarketBloc.close();
    checkoutCubit.close();
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
        'should add product to list when [SupermarketSelectProductPressed] is added',
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
        },
      );

      blocTest<SupermarketBloc, SupermarketState>(
        'should remove product to list when [SupermarketProductRemoveSelectedPressed] is added',
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
  });
}
