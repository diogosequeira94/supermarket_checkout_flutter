// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_n_get_free_promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyNGetFreePromotion _$BuyNGetFreePromotionFromJson(
        Map<String, dynamic> json) =>
    BuyNGetFreePromotion(
      productId: json['productId'] as String,
      amountNeeded: (json['amountNeeded'] as num).toInt(),
    );

Map<String, dynamic> _$BuyNGetFreePromotionToJson(
        BuyNGetFreePromotion instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'amountNeeded': instance.amountNeeded,
    };
