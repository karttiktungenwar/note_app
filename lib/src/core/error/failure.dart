abstract class Failure {
  final String message;

  const Failure({required this.message});

   @override
  String toString() => message;
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NoDataFailure extends Failure {
  const NoDataFailure({required super.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No Internet Connection'});
}

class DefaultFailure extends Failure {
  const DefaultFailure({super.message = 'Some Error error'});
}
