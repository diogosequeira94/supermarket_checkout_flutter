import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluro_checkout/repository/models/product/product.dart';
import 'package:fluro_checkout/view/widgets/product_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsList extends StatelessWidget {
  final List<Product> products;

  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final supermarketBloc = context.read<SupermarketBloc>();
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
          onTap: () => supermarketBloc.add(
            SupermarketSelectProductPressed(
              product: product,
            ),
          ),
          name: product.name,
          price: product.price,
          imageId: product.imageId,
        );
      },
    );
  }
}
