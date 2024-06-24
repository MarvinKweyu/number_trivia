import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia {
  final NumberTriviaRepository repo;

  GetRandomNumberTrivia(this.repo);

  Future<Either<Failure, NumberTrivia>> execute() async {
    return await repo.getRandomNumberTrivia();
  }
}
