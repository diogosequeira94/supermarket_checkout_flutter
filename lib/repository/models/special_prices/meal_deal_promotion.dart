import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_deal_promotion.g.dart';

@JsonSerializable()
class MealDealPromotion extends Equatable {
  @JsonKey(name: 'productIds')
  final List<String> productIds;
  @JsonKey(name: 'dealPrice')
  final int dealPrice;

  const MealDealPromotion({
    required this.productIds,
    required this.dealPrice,
  });

  @override
  List<Object?> get props => [
    productIds,
    dealPrice,
  ];

  factory MealDealPromotion.fromJson(Map<String, dynamic> json) =>
      _$MealDealPromotionFromJson(json);

  Map<String, dynamic> toJson() => _$MealDealPromotionToJson(this);
}
