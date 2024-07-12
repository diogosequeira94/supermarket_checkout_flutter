import 'package:equatable/equatable.dart';
import 'package:fluro_checkout/repository/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supermarket_info_response.g.dart';

@JsonSerializable()
class SupermarketInfoResponse extends Equatable {
  @JsonKey(name: 'products')
  final List<Product> products;
  @JsonKey(name: 'specialPrices')
  final SpecialPrices specialPrices;

  const SupermarketInfoResponse({
    required this.products,
    required this.specialPrices,
  });

  @override
  List<Object?> get props => [
        products,
        specialPrices,
      ];

  factory SupermarketInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$SupermarketInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupermarketInfoResponseToJson(this);
}
