abstract class SupermarketException implements Exception {
  int get statusCode;
}

/// Exception thrown when the user is not authenticated (i.e. token expired)
class SupermarketUnauthorizedException extends SupermarketException {
  @override
  int get statusCode => 401;
}

/// Thrown when there is an internal server error or the service is not available
class SupermarketServiceNotAvailableException extends SupermarketException {
  final int _statusCode;

  SupermarketServiceNotAvailableException({
    required int statusCode,
  }) : _statusCode = statusCode;

  @override
  int get statusCode => _statusCode;
}

/// Thrown when an unknown error is returned from the API
class SupermarketUnknownErrorException extends SupermarketException {
  final int _statusCode;

  SupermarketUnknownErrorException({
    required int statusCode,
  }) : _statusCode = statusCode;

  @override
  int get statusCode => _statusCode;
}
