import 'package:flutter/material.dart';
import 'package:fluro_checkout/repository/models/product.dart';
import 'package:fluro_checkout/view/widgets/product_item.dart';

class ProductsList extends StatelessWidget {
  final List<Product> products;

  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Adjust the number of columns as needed
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 2, // Adjust the aspect ratio as needed
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(
          name: product.name,
          price: product.price,
          imageId: product.imageId,
        );
      },
    );
  }
}
