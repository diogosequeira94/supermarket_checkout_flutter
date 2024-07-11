part of 'checkout_cubit.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {
  @override
  List<Object> get props => [];
}

final class CheckoutLoadInProgress extends CheckoutState {
  @override
  List<Object> get props => [];
}

final class CheckoutLoadSuccess extends CheckoutState {
  @override
  List<Object> get props => [];
}

final class CheckoutLoadError extends CheckoutState {
  final String errorMessage;

  const CheckoutLoadError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
