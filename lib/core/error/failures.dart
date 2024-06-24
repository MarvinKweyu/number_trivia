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
