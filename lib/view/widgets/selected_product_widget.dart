import 'package:fluro_checkout/repository/models/models.dart';
import 'package:flutter/material.dart';

class SelectedProductWidget extends StatelessWidget {
  const SelectedProductWidget({
    super.key,
    required this.product,
    required this.onTap,
  });

  final VoidCallback onTap;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('${product.price.toString()}p'),
        trailing: IconButton(
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
