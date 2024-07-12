import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../errors/errors.dart';
import '../models/models.dart';

class SupermarketApiClient {
  const SupermarketApiClient();

  /// Fetch products
  ///
  /// Throws [SupermarketUnauthorizedException] if user is not authorized
  /// [SupermarketServiceNotAvailableException] if service runs into
  /// internal error or service is not available
  /// [SupermarketUnknownErrorException] if unknown error occurred
  Future<List<Product>> fetchProducts() async {
    try {
      final response =
          await rootBundle.loadString('lib/repository/data/mock-products.json');
      final productsJson = json.decode(response)['products'] as List<dynamic>;
      // Simulates the request time
      await Future.delayed(const Duration(seconds: 1));
      return [
        for (final product in productsJson) Product.fromJson(product),
      ];
    } on Object catch (_) {
      final exceptionCode = _generateRandomException();
      throw _mapStatusCodeToException(exceptionCode);
    }
  }

  /// Get Special Prices
  ///
  /// Throws [SupermarketUnauthorizedException] if user is not authorized
  /// [SupermarketServiceNotAvailableException] if service runs into
  /// internal error or service is not available
  /// [SupermarketUnknownErrorException] if unknown error occurred
  Future<SpecialPrices> getSpecialPrices() async {
    try {
      final response = await rootBundle
          .loadString('lib/repository/data/mock-special-prices.json');
      final specialPricesJson = json.decode(response);
      // Simulates the request time
      await Future.delayed(const Duration(seconds: 1));
      return SpecialPrices.fromJson(specialPricesJson);
    } on Object catch (_) {
      final exceptionCode = _generateRandomException();
      throw _mapStatusCodeToException(exceptionCode);
    }
  }

  /// Preload Supermarket Info
  ///
  /// Throws [SupermarketUnauthorizedException] if user is not authorized
  /// [SupermarketServiceNotAvailableException] if service runs into
  /// internal error or service is not available
  /// [SupermarketUnknownErrorException] if unknown error occurred
  Future<SupermarketInfoResponse> preloadSupermarketInfo() async {
    try {
      final response = await rootBundle.loadString(
          'lib/repository/data/mock-supermarket-info-response.json');
      final supermarketInfoJson = json.decode(response);
      // Simulates the request time
      await Future.delayed(const Duration(seconds: 1));
      return SupermarketInfoResponse.fromJson(supermarketInfoJson);
    } on Object catch (_) {
      final exceptionCode = _generateRandomException();
      throw _mapStatusCodeToException(exceptionCode);
    }
  }

  SupermarketException _mapStatusCodeToException(int statusCode) {
    switch (statusCode) {
      case 401:
        return SupermarketUnauthorizedException();
      case 500:
      case 503:
        return SupermarketServiceNotAvailableException(statusCode: statusCode);
      default:
        return SupermarketUnknownErrorException(statusCode: statusCode);
    }
  }

  // A mock exception
  int _generateRandomException() {
    final random = Random();
    final numbers = [401, 500, 503];
    final randomIndex = random.nextInt(numbers.length);
    return numbers[randomIndex];
  }
}
