import 'package:fluro_checkout/repository/api/supermarket_api_client.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSuperMarketApiClient extends Mock implements SupermarketApiClient {}

void main() {
  late SupermarketRepository supermarketRepository;
  late SupermarketApiClient supermarketApiClient;

  setUp(() {
    supermarketApiClient = MockSuperMarketApiClient();
    supermarketRepository =
        SupermarketRepository(supermarketApiClient: supermarketApiClient);
  });

  group('SupermarketRepository', () {
    final products = [
      const Product(name: 'A', price: 25, imageId: 'mockImageId')
    ];
    const specialPrices = SpecialPrices(
      multiPricedPromotions: null,
      mealDealPromotions: null,
      buyNGetFreePromotions: null,
    );
    final preloadInformation = SupermarketInfoResponse(
        products: products, specialPrices: specialPrices);

    test('client is called and responds with products', () async {
      when(() => supermarketApiClient.fetchProducts()).thenAnswer(
        (_) => Future.value(products),
      );

      final response = await supermarketApiClient.fetchProducts();

      expect(response, products);
    });

    test('client is called and responds with special prices', () async {
      when(() => supermarketApiClient.getSpecialPrices()).thenAnswer(
        (_) => Future.value(specialPrices),
      );

      final response = await supermarketApiClient.getSpecialPrices();

      expect(response, specialPrices);
    });

    test('client is called and responds with preloadInformation', () async {
      when(() => supermarketApiClient.preloadSupermarketInfo()).thenAnswer(
        (_) => Future.value(preloadInformation),
      );

      final response = await supermarketApiClient.preloadSupermarketInfo();

      expect(response, preloadInformation);
    });
  });
}
