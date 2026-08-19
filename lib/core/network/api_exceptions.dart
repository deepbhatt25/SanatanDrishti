class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException({
    super.message = 'No internet connection. Using cached data.',
    super.originalError,
  });
}

class ServerException extends ApiException {
  ServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class CacheException extends ApiException {
  CacheException({
    required super.message,
    super.originalError,
  });
}
