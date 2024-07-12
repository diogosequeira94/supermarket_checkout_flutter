import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/repository.dart';

part 'supermarket_event.dart';
part 'supermarket_state.dart';

class SupermarketBloc extends Bloc<SupermarketEvent, SupermarketState> {
  SupermarketBloc({required SupermarketRepository supermarketRepository})
      : _supermarketRepository = supermarketRepository,
        super(const SupermarketState(
            status: SupermarketStatus.initial,
            selectedProducts: [],
            totalAmount: 0)) {
    on<SupermarketLoadStarted>((event, emit) async {
      await _preloadSupermarketInfo(emit);
    });
    on<SupermarketProductOperationPressed>((event, emit) {
      _performProductListOperation(event, emit);
    });
  }

  final SupermarketRepository _supermarketRepository;
  late SpecialPrices _specialPrices;

  Future<void> _preloadSupermarketInfo(Emitter<SupermarketState> emit) async {
    try {
      emit(state.copyWith(status: SupermarketStatus.loading));

      final supermarketInfo =
          await _supermarketRepository.preloadSupermarketInfo();
      _specialPrices = supermarketInfo.specialPrices;

      emit(state.copyWith(
        status: SupermarketStatus.loaded,
        products: supermarketInfo.products,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
          status: SupermarketStatus.error,
          errorMessage: _convertToExceptionLog(e)));
    }
  }

  void _performProductListOperation(SupermarketProductOperationPressed event,
      Emitter<SupermarketState> emit) {
    final selectedProductsList = List<Product>.from(state.selectedProducts);

    event.operation == ProductOperation.add
        ? selectedProductsList.add(event.product)
        : selectedProductsList.remove(event.product);

    final updatedAmount = _updateTotalAmount(selectedProductsList);
    emit(state.copyWith(
        selectedProducts: selectedProductsList, totalAmount: updatedAmount));
  }

  int _updateTotalAmount(List<Product> selectedProducts) {
    final updatedAmount =
        selectedProducts.fold(0, (total, product) => total + product.price);
    return updatedAmount;
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
