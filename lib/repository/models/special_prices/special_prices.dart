import 'package:equatable/equatable.dart';
import 'package:fluro_checkout/repository/models/special_prices/buy_n_get_free_promotion.dart';
import 'package:fluro_checkout/repository/models/special_prices/meal_deal_promotion.dart';
import 'package:fluro_checkout/repository/models/special_prices/multi_priced_promotion.dart';
import 'package:json_annotation/json_annotation.dart';

part 'special_prices.g.dart';

@JsonSerializable()
class SpecialPrices extends Equatable {
  @JsonKey(name: 'multiPriced')
  final List<MultiPricedPromotion>? multiPricedPromotions;
  @JsonKey(name: 'buyNGetFree')
  final List<BuyNGetFreePromotion>? buyNGetFreePromotions;
  @JsonKey(name: 'mealDeal')
  final List<MealDealPromotion>? mealDealPromotions;

  const SpecialPrices({
    required this.multiPricedPromotions,
    required this.buyNGetFreePromotions,
    required this.mealDealPromotions,
  });

  @override
  List<Object?> get props => [
        multiPricedPromotions,
        buyNGetFreePromotions,
        mealDealPromotions,
      ];

  factory SpecialPrices.fromJson(Map<String, dynamic> json) =>
      _$SpecialPricesFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialPricesToJson(this);
}
