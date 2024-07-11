import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro_checkout/repository/repository.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({required SupermarketRepository supermarketRepository})
      : _supermarketRepository = supermarketRepository,
        super(CheckoutInitial());

  final SupermarketRepository _supermarketRepository;

  Future<void> getCurrentPromotions(List<Product> checkoutProducts) async {
    try {
      emit(CheckoutLoadInProgress());
      final promotions = await _supermarketRepository.getPromotions();

      if (promotions != null) {
        /// Apply Promotions
      }

      emit(CheckoutLoadSuccess());
    } on Object catch (e) {
      emit(CheckoutLoadError(errorMessage: e.toString()));
    }
  }
}
