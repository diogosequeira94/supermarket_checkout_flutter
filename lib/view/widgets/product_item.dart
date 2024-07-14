import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final int price;
  final String imageId;

  const ProductItem({
    super.key,
    required this.onTap,
    required this.name,
    required this.price,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 14.0, 8.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: Image.asset(
              imageId,
              height: 35,
              width: 35,
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(' - $price pence', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
