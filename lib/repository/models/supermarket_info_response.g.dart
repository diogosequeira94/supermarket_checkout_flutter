// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supermarket_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupermarketInfoResponse _$SupermarketInfoResponseFromJson(
        Map<String, dynamic> json) =>
    SupermarketInfoResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialPrices:
          SpecialPrices.fromJson(json['specialPrices'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupermarketInfoResponseToJson(
        SupermarketInfoResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
      'specialPrices': instance.specialPrices,
    };
