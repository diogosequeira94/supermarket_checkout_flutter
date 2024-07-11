import 'package:fluro_checkout/repository/models/models.dart';
import 'package:flutter/material.dart';

class SelectedProductWidget extends StatelessWidget {
  const SelectedProductWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.isCheckout,
  });

  final VoidCallback onTap;
  final Product product;
  final bool isCheckout;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('${product.price.toString()}p'),
        trailing: isCheckout
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: onTap,
              ),
      ),
    );
  }
}
