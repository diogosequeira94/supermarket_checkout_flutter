import 'package:fluro_checkout/repository/api/supermarket_api_client.dart';
import 'package:lumberdash/lumberdash.dart';
import 'models/models.dart';

abstract class ISupermarketRepository {
  Future<List<Product>> fetchProducts();
  Future<SpecialPrices?> getSpecialPrices();
  Future<SupermarketInfoResponse> preloadSupermarketInfo();
}

class SupermarketRepository implements ISupermarketRepository {
  final SupermarketApiClient _supermarketApiClient;

  SupermarketRepository._internal(
      {required SupermarketApiClient supermarketApiClient})
      : _supermarketApiClient = supermarketApiClient;

  static SupermarketRepository? _instance;

  factory SupermarketRepository(
      {required SupermarketApiClient supermarketApiClient}) {
    return _instance ??= SupermarketRepository._internal(
        supermarketApiClient: supermarketApiClient);
  }

  @override
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

  @override
  Future<SpecialPrices?> getSpecialPrices() async {
    try {
      final specialPrices = await _supermarketApiClient.getSpecialPrices();
      logMessage(
          '[SupermarketRepository] Finished getting promotions successfully.');
      return specialPrices;
    } on Object catch (e) {
      logError(
          '[SupermarketRepository]: Getting promotions failed with error $e');
      rethrow;
    }
  }

  @override
  Future<SupermarketInfoResponse> preloadSupermarketInfo() async {
    try {
      final supermarketInfo =
          await _supermarketApiClient.preloadSupermarketInfo();
      logMessage(
          '[SupermarketRepository] Finished preloading supermarket information successfully.');
      return supermarketInfo;
    } on Object catch (e) {
      logError(
          '[SupermarketRepository]: Preload supermarket information failed with error $e');
      rethrow;
    }
  }
}
