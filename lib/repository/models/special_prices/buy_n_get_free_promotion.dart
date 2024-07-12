import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'buy_n_get_free_promotion.g.dart';

@JsonSerializable()
class BuyNGetFreePromotion extends Equatable {
  @JsonKey(name: 'productId')
  final String productId;
  @JsonKey(name: 'amountNeeded')
  final int amountNeeded;

  const BuyNGetFreePromotion({
    required this.productId,
    required this.amountNeeded,
  });

  @override
  List<Object?> get props => [productId, amountNeeded];

  factory BuyNGetFreePromotion.fromJson(Map<String, dynamic> json) =>
      _$BuyNGetFreePromotionFromJson(json);

  Map<String, dynamic> toJson() => _$BuyNGetFreePromotionToJson(this);
}
