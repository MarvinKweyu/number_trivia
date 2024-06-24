import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repo;

  GetConcreteNumberTrivia(this.repo);

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async{
    return await repo.getConcreteNumberTrivia(number: number);
  }
}
