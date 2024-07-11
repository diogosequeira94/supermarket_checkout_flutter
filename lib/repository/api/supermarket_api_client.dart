import 'dart:convert';
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

      return [
        for (final product in productsJson) Product.fromJson(product),
      ];
    } on Object catch (_) {
      throw _mapStatusCodeToException(400);
    }
  }

  /// Get Promotions
  ///
  /// Throws [SupermarketUnauthorizedException] if user is not authorized
  /// [SupermarketServiceNotAvailableException] if service runs into
  /// internal error or service is not available
  /// [SupermarketUnknownErrorException] if unknown error occurred
  Future<Object> getPromotions() async {
    /// ToDo: Think about Promotion object
    try {
      return '';
    } on Object catch (_) {
      throw _mapStatusCodeToException(400);
    }
  }

  /// Preload Supermarket Info
  ///
  /// Throws [SupermarketUnauthorizedException] if user is not authorized
  /// [SupermarketServiceNotAvailableException] if service runs into
  /// internal error or service is not available
  /// [SupermarketUnknownErrorException] if unknown error occurred
  Future<Object> preloadSupermarketInfo() async {
    /// ToDo: Returns response object with promotions and products
    try {
      return '';
    } on Object catch (_) {
      throw _mapStatusCodeToException(400);
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
}
