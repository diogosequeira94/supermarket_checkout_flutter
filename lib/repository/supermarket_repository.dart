import 'package:fluro_checkout/repository/api/supermarket_api_client.dart';
import 'package:lumberdash/lumberdash.dart';
import 'models/models.dart';

class SupermarketRepository {
  /// ToDo: Turn into Singleton or RepoProvider
  final SupermarketApiClient _supermarketApiClient;
  const SupermarketRepository(
      {required SupermarketApiClient supermarketApiClient})
      : _supermarketApiClient = supermarketApiClient;

  Future<List<Product>> fetchProducts() async {
    try {
      final products = await _supermarketApiClient.fetchProducts();
      logMessage(
          '[SupermarketRepository] Finished fetchProducts successfully.');
      return products;
    } on Object catch (e) {
      logError('[SupermarketRepository]: fetchProducts failed with error $e');
      rethrow;
    }
  }

  Future<Object> getPromotions() async {
    return Object();
  }

  Future<Object> preloadSupermarketInfo() async {
    return Object();
  }
}
