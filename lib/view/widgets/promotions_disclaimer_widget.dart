import 'package:flutter/material.dart';

class PromotionsDisclaimerWidget extends StatelessWidget {
  const PromotionsDisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info,
          color: Colors.white,
        ),
        SizedBox(width: 4.0),
        Flexible(
          child: Text(
            'Promotions are calculated automatically',
            style: TextStyle(color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
