import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'price')
  final int price;
  @JsonKey(name: 'imageId')
  final String imageId;

  const Product({
    required this.name,
    required this.price,
    required this.imageId,
  });

  @override
  List<Object?> get props => [name, price, imageId];

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
