import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late NumberTriviaRepository repo;

  setUp(() {
    repo = MockNumberTriviaRepo();
    usecase = GetRandomNumberTrivia(repo);
  });
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should return a random number from the repo', () async {
    // arrange
    when(() => repo.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    // act
    final result = await usecase.execute();
    expect(result, const Right(tNumberTrivia));
    // verify the method has been called and once
    verify(() => repo.getRandomNumberTrivia()).called(1);
  });
}
