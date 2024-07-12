import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSupermarketRepository extends Mock implements SupermarketRepository {}

class MockCheckoutCubit extends Mock implements CheckoutCubit {}

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
    checkoutCubit.close();
  });

  group('NativeSchedulingOrchestratorBloc', () {});
}
