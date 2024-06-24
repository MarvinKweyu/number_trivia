import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // const Failure([List properties = const <dynamic>[]]); super(properties);

  final String message;
  final int statusCode;

  const Failure({
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure{
  const ServerFailure({required super.message, required super.statusCode});
}
class CacheFailure extends Failure{
  const CacheFailure({required super.message, required super.statusCode});
}