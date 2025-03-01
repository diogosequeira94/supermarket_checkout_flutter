import 'package:fluro_checkout/repository/repository.dart';

const multiPricePromotion =
    MultiPricedPromotion(productId: 'A', quantity: 3, specialPrice: 120);

const buyNGetFreePromotion =
    BuyNGetFreePromotion(productId: 'A', amountNeeded: 4);

const mealDealPromotion = MealDealPromotion(
  dealPrice: 300,
  productIds: ['D', 'E'],
);
