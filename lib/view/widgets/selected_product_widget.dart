import 'package:fluro_checkout/model/selected_product.dart';
import 'package:flutter/material.dart';

class SelectedProductWidget extends StatelessWidget {
  const SelectedProductWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.isCheckout,
  });

  final VoidCallback onTap;
  final SelectedProduct product;
  final bool isCheckout;

  @override
  Widget build(BuildContext context) {
    final isPromotionApplied =
        (product.oldPrice != null && product.oldPrice != product.currentPrice);
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name),
                  if (isPromotionApplied)
                    Text(
                      '${product.oldPrice.toString()}p',
                      style: const TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text('${product.currentPrice.toString()}p'),
                ],
              ),
            ),
          ],
        ),
        subtitle: isPromotionApplied
            ? const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text('Promotion Applied!'),
              )
            : const SizedBox.shrink(),
        trailing: isCheckout
            ? const SizedBox.shrink()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPromotionApplied)
                    IconButton(
                      icon: const Icon(
                        Icons.info,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () => _openPromotionInfoDialog(context),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: onTap,
                  ),
                ],
              ),
      ),
    );
  }

  void _openPromotionInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promotion Information'),
          content: const Text(
            'Multi-priced Promotion: Buy 3 for £1.30\n'
            'This information helps users understand the promotions they are getting.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
