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
            status: SupermarketStatus.initial, selectedProducts: [])) {
    on<SupermarketLoadStarted>((event, emit) async {
      await _getProducts(emit);
    });
    on<SupermarketAddProduct>((event, emit) {
      _addProduct(event, emit);
    });
    on<SupermarketRemoveProduct>((event, emit) {
      _removeProduct(event, emit);
    });
  }

  final SupermarketRepository _supermarketRepository;

  Future<void> _getProducts(Emitter<SupermarketState> emit) async {
    try {
      emit(state.copyWith(status: SupermarketStatus.loading));
      final products = await _supermarketRepository.fetchProducts();
      emit(state.copyWith(
        status: SupermarketStatus.loaded,
        products: products,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
          status: SupermarketStatus.error,
          errorMessage: _convertToExceptionLog(e)));
    }
  }

  void _addProduct(
      SupermarketAddProduct event, Emitter<SupermarketState> emit) {
    final newSelectedProductsList = List<Product>.from(state.selectedProducts);
    newSelectedProductsList.add(event.product);
    emit(state.copyWith(selectedProducts: newSelectedProductsList));
  }

  void _removeProduct(
      SupermarketRemoveProduct event, Emitter<SupermarketState> emit) {
    final newSelectedProductsList = List<Product>.from(state.selectedProducts);
    newSelectedProductsList.remove(event.product);
    emit(state.copyWith(selectedProducts: newSelectedProductsList));
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
