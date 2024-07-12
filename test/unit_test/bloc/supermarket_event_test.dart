import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/repository/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const product = Product(name: 'A', price: 20, imageId: 'mockImage');
  group('SupermarketEvent', () {
    group('SupermarketLoadStarted', () {
      test('props', () {
        expect(
          const SupermarketLoadStarted().props,
          [],
        );
      });
    });
    group('SupermarketSelectProductPressed', () {
      test('props', () {
        expect(
          const SupermarketSelectProductPressed(product: product).props,
          [product],
        );
      });
    });
    group('SupermarketProductRemoveSelectedPressed', () {
      test('props', () {
        expect(
          SupermarketProductRemoveSelectedPressed(
                  selectedProductName: product.name)
              .props,
          [product.name],
        );
      });
    });
  });
}
