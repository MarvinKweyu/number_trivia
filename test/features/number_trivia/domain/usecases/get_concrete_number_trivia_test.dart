import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late NumberTriviaRepository repo;

  setUp(() {
    repo = MockNumberTriviaRepo();
    usecase = GetConcreteNumberTrivia(repo);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia for the number from teh repo', () async {
    // arrange
    // act
    //assert
    //
    when(() => repo.getConcreteNumberTrivia(number: any(named: 'number')))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    //* act
    // calling not yet existent method
    final result = await usecase(const Params(number: tNumber));
    // usecase should return anything that was returned from the repo
    expect(result, const Right(tNumberTrivia));
    // verify that the method hs been called on the repo
    // make sure that we are callng the repo with the actual no
    verify(() => repo.getConcreteNumberTrivia(number: tNumber)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
