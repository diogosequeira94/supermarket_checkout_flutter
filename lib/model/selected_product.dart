import 'package:equatable/equatable.dart';

/// A UI Model that should be used to interact with a [Product]
class SelectedProduct extends Equatable {
  final String name;
  final num? oldPrice;
  final int currentPrice;
  final String promotionApplied;

  const SelectedProduct({
    required this.name,
    this.oldPrice,
    required this.currentPrice,
    required this.promotionApplied,
  });

  @override
  List<Object?> get props => [name, oldPrice, currentPrice, promotionApplied];
}
