import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  // call https://numbersapi.com/{number}
  // throw [serverException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  // call https://numbersapi.com/random
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
