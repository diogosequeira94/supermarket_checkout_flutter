import 'package:bloc_test/bloc_test.dart';
import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:mocktail/mocktail.dart';

class MockSupermarketRepository extends Mock implements SupermarketRepository {}

class MockSupermarketBloc extends MockBloc<SupermarketEvent, SupermarketState>
    implements SupermarketBloc {}

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}
