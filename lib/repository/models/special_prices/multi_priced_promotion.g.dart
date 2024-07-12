// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_priced_promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiPricedPromotion _$MultiPricedPromotionFromJson(
        Map<String, dynamic> json) =>
    MultiPricedPromotion(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      specialPrice: (json['specialPrice'] as num).toInt(),
    );

Map<String, dynamic> _$MultiPricedPromotionToJson(
        MultiPricedPromotion instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'specialPrice': instance.specialPrice,
    };
