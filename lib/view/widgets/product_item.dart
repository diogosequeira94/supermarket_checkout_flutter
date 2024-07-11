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
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imageId,
              height: 60,
              width: 60,
            ),
            Text(name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$price pence', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
