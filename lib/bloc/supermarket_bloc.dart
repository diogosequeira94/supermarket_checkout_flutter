import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:flutter/cupertino.dart';

import '../repository/repository.dart';

part 'supermarket_event.dart';
part 'supermarket_state.dart';

class SupermarketBloc extends Bloc<SupermarketEvent, SupermarketState> {
  SupermarketBloc({
    required SupermarketRepository supermarketRepository,
    required CheckoutCubit checkoutCubit,
  })  : _supermarketRepository = supermarketRepository,
        _checkoutCubit = checkoutCubit,
        super(const SupermarketState(
          status: SupermarketStatus.initial,
          selectedProducts: [],
        )) {
    on<SupermarketLoadStarted>(_preloadSupermarketInfo);
    on<SupermarketSelectProductPressed>(_scanProduct);
    on<SupermarketProductRemoveSelectedPressed>(_removeSelectedProduct);
    on<SupermarketFinishShopPressed>(_finishShop);
  }

  final SupermarketRepository _supermarketRepository;
  final CheckoutCubit _checkoutCubit;

  late List<Product> _products;
  late SpecialPrices _specialPrices;

  @visibleForTesting
  SpecialPrices get specialPrices => _specialPrices;

  Future<void> _preloadSupermarketInfo(
      SupermarketLoadStarted event, Emitter<SupermarketState> emit) async {
    emit(state.copyWith(status: SupermarketStatus.loading));
    try {
      final supermarketInfo =
          await _supermarketRepository.preloadSupermarketInfo();

      _products = supermarketInfo.products;
      _specialPrices = supermarketInfo.specialPrices;

      emit(state.copyWith(
        status: SupermarketStatus.loaded,
        products: _products,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
          status: SupermarketStatus.error,
          errorMessage: _convertToExceptionLog(e)));
    }
  }

  /// Used to perform operations on [selectedProducts]
  /// Can either add (scan) or remove products from the list
  /// Delegates to CheckoutCubit
  void _scanProduct(
      SupermarketSelectProductPressed event, Emitter<SupermarketState> emit) {
    final selectedProductsList = List<Product>.from(state.selectedProducts);

    selectedProductsList.add(event.product);

    _checkoutCubit.updateCheckout(selectedProductsList, _specialPrices);

    emit(state.copyWith(selectedProducts: selectedProductsList));
  }

  void _removeSelectedProduct(SupermarketProductRemoveSelectedPressed event,
      Emitter<SupermarketState> emit) {
    final selectedProductsList = List<Product>.from(state.selectedProducts);

    // Remove only one instance of the product
    final index = selectedProductsList.indexWhere((product) {
      final productName = product.name;
      final selectedName = event.selectedProductName;

      if (productName == 'D' || productName == 'E' && selectedName == 'D + E') {
        /// Remove one D and one E
        return true;
      }

      return productName == selectedName;
    });

    if (index != -1) {
      selectedProductsList.removeAt(index);
    }

    _checkoutCubit.updateCheckout(selectedProductsList, _specialPrices);

    emit(state.copyWith(selectedProducts: selectedProductsList));
  }

  Future<void> _finishShop(SupermarketFinishShopPressed event,
      Emitter<SupermarketState> emit) async {
    _checkoutCubit.resetCheckout();

    try {
      emit(state
          .copyWith(status: SupermarketStatus.loading, selectedProducts: []));

      final promotions = await _supermarketRepository.getSpecialPrices();
      if (promotions != null) {
        _specialPrices = promotions;
      }

      emit(state.copyWith(
        status: SupermarketStatus.loaded,
        products: _products,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
          status: SupermarketStatus.error,
          errorMessage: _convertToExceptionLog(e)));
    }
  }

  String _convertToExceptionLog(Object exception) {
    String errorMessage;
    switch (exception.runtimeType) {
      case const (SupermarketUnauthorizedException):
        errorMessage = 'Ooops, unauthorized exception occurred!';
        break;
      case const (SupermarketServiceNotAvailableException):
        errorMessage = 'Ooops, service seems to be down!';
        break;
      default:
        errorMessage = 'Ooops, something went wrong, please try again!';
        break;
    }
    return errorMessage;
  }
}
