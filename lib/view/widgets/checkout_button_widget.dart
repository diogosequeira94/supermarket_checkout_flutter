import 'package:flutter/material.dart';

class CheckoutButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const CheckoutButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('checkoutButton_key'),
      onPressed: () {
        onTap();
      },
      child: const Text('Checkout'),
    );
  }
}
