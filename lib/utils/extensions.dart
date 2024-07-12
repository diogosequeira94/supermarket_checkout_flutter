import '../repository/models/models.dart';

/// Used to calculate the price for a product based on a multi-priced promotion
/// (e.g: buy 3 for a special price).
extension MultiPriceExtension on MultiPricedPromotion {
  int calculatePrice(int itemCount, int unitPrice) {
    final setsOfItems = itemCount ~/ quantity;
    final remainingLeftovers = itemCount % quantity;
    return setsOfItems * specialPrice + remainingLeftovers * unitPrice;
  }
}

/// Used to calculate an offer in case someone buys a specific amount
/// (e.g: buy 2 get one free).
extension BuyNGetFreeExtension on BuyNGetFreePromotion {
  int calculatePrice(int itemCount, int unitPrice) {
    /// If the number of items select was more the amountNeeded to get an offer
    if (itemCount >= amountNeeded) {
      // Number of sets that qualify for the promotion
      final setsOfItems = itemCount ~/ (amountNeeded + 1);
      // Remaining items that do not belong to a set
      final remainingItems = itemCount % (amountNeeded + 1);
      // Total price for the items including the promotion
      return setsOfItems * amountNeeded * unitPrice +
          remainingItems * unitPrice;
    } else {
      // If there are not enough items to qualify for the promotion, pay the unit price
      return itemCount * unitPrice;
    }
  }
}
