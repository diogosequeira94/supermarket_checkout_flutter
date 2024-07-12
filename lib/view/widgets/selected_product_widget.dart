import 'package:fluro_checkout/model/selected_product.dart';
import 'package:fluro_checkout/utils/shared_strings.dart';
import 'package:flutter/cupertino.dart';
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
                        color: Colors.grey,
                      ),
                    ),
                  Text('${product.currentPrice.toString()}p'),
                ],
              ),
            ),
          ],
        ),
        subtitle: isPromotionApplied
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6.0)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.5, horizontal: 8.0),
                      child: Text(
                        'Promotion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
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
                      onPressed: () => _openPromotionInfoDialog(
                          context, product.promotionApplied),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: onTap,
                  ),
                ],
              ),
      ),
    );
  }

  void _openPromotionInfoDialog(BuildContext context, String promotionApplied) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Special Price Added'),
          content: Text(
            '$promotionApplied\n\n'
            '${_getPromotionDescription(promotionApplied)}',
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

  String _getPromotionDescription(String promotionApplied) {
    switch (promotionApplied) {
      case SharedStrings.multiPricedPromotion:
        return 'When shopping for this item you get a special price when buying an X amount, enjoy!';
      case SharedStrings.buyNGetFree:
        return 'When shopping for this item you get a special offer when buying an X amount, enjoy!';
      default:
        return '';
    }
  }
}
