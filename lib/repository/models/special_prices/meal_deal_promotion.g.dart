// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_deal_promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealDealPromotion _$MealDealPromotionFromJson(Map<String, dynamic> json) =>
    MealDealPromotion(
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dealPrice: (json['dealPrice'] as num).toInt(),
    );

Map<String, dynamic> _$MealDealPromotionToJson(MealDealPromotion instance) =>
    <String, dynamic>{
      'productIds': instance.productIds,
      'dealPrice': instance.dealPrice,
    };
