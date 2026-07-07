/// Thrown when the server returns a non-success status code
class ServerException implements Exception {
  final String message;

  ServerException({required this.message});

  @override
  String toString() => message;
}

/// Thrown when the local database (Hive/Isar) fails
class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => message;
}

/// Thrown when there is no internet connection detected
class NetworkException implements Exception {}
