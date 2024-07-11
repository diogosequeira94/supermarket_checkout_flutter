import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/view/widgets/selected_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluro_checkout/repository/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedProductsList extends StatelessWidget {
  final List<Product> products;
  final bool allowRemoval;

  const SelectedProductsList(
      {super.key, required this.products, this.allowRemoval = true});

  @override
  Widget build(BuildContext context) {
    final supermarketBloc = context.read<SupermarketBloc>();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return SelectedProductWidget(
          product: product,
          isCheckout: !allowRemoval,
          onTap: () {
            supermarketBloc.add(
              SupermarketProductOperationPressed(
                  operation: ProductOperation.remove, product: product),
            );
          },
        );
      },
    );
  }
}
