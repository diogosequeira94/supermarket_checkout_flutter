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
    final ScrollController scrollController = ScrollController();
    final phoneHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: phoneHeight * 0.35,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true, // Use this instead
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: products.length,
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
        ),
      ),
    );
  }
}
