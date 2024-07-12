import '../repository/models/models.dart';

/// Used to calculate the price for a product based on a multi-priced promotion
/// (e.g: buy 3 for a special price).
extension on MultiPricedPromotion {
  int calculatePrice(int itemCount, int unitPrice) {
    final setsOfItems = itemCount ~/ quantity;
    final remainingLeftovers = itemCount % quantity;
    return setsOfItems * specialPrice + remainingLeftovers * unitPrice;
  }
}
