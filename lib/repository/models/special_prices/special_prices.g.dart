// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_prices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialPrices _$SpecialPricesFromJson(Map<String, dynamic> json) =>
    SpecialPrices(
      multiPricedPromotions: (json['multiPriced'] as List<dynamic>?)
          ?.map((e) => MultiPricedPromotion.fromJson(e as Map<String, dynamic>))
          .toList(),
      buyNGetFreePromotions: (json['buyNGetFree'] as List<dynamic>?)
          ?.map((e) => BuyNGetFreePromotion.fromJson(e as Map<String, dynamic>))
          .toList(),
      mealDealPromotions: (json['mealDeal'] as List<dynamic>?)
          ?.map((e) => MealDealPromotion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpecialPricesToJson(SpecialPrices instance) =>
    <String, dynamic>{
      'multiPriced': instance.multiPricedPromotions,
      'buyNGetFree': instance.buyNGetFreePromotions,
      'mealDeal': instance.mealDealPromotions,
    };
