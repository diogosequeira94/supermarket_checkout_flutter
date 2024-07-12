import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multi_priced_promotion.g.dart';

@JsonSerializable()
class MultiPricedPromotion extends Equatable {
  @JsonKey(name: 'productId')
  final String productId;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'specialPrice')
  final int specialPrice;

  const MultiPricedPromotion({
    required this.productId,
    required this.quantity,
    required this.specialPrice,
  });

  factory MultiPricedPromotion.fromJson(Map<String, dynamic> json) =>
      _$MultiPricedPromotionFromJson(json);
  Map<String, dynamic> toJson() => _$MultiPricedPromotionToJson(this);

  @override
  List<Object?> get props => [productId, quantity, specialPrice];
}
