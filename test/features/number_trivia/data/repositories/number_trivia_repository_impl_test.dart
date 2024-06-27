// ignore_for_file: void_checks

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repo;
  late MockRemoteDataSource mockRemoteSource;
  late MockLocalDataSource mockLocalSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(const NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    ));
  });

  setUp(() {
    mockRemoteSource = MockRemoteDataSource();
    mockLocalSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repo = NumberTriviaRepositoryImpl(
      remoteSource: mockRemoteSource,
      localSource: mockLocalSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      // arrange
      when(() => mockLocalSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => Future.value(false));
      when(() => mockRemoteSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repo.getConcreteNumberTrivia(number: tNumber);

      //asert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when remote data source is successful',
          () async {
        // arrange
        when(() => mockLocalSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async => Future.value(false));
        when(() => mockRemoteSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockRemoteSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repo.getConcreteNumberTrivia(number: tNumber);

        // assert
        // did we call you with teh correct param?
        verify(() => mockRemoteSource.getConcreteNumberTrivia(tNumber))
            .called(1);
        // we can explicitly place it
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache data locally when the call to remote is successful',
          () async {
        when(() => mockLocalSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async => Future.value(false));
        when(() => mockRemoteSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repo.getConcreteNumberTrivia(number: tNumber);
        verify(() => mockRemoteSource.getConcreteNumberTrivia(tNumber))
            .called(1);
        verify(() => mockLocalSource.cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // act
        final result = await repo.getConcreteNumberTrivia(number: tNumber);
        // assert
        verify(() => mockRemoteSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when cached data is present',
          () async {
        when(() => mockLocalSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repo.getConcreteNumberTrivia(number: tNumber);

        // assert
        // verifyZeroInteractions(() => mockRemoteSource);
        verify(() => mockLocalSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaModel)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repo.getConcreteNumberTrivia(number: tNumber);
        // assert
        verifyZeroInteractions(mockRemoteSource);
        verify(() => mockLocalSource.getLastNumberTrivia()).called(1);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: 123);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      // arrange
      when(() => mockLocalSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => Future.value(false));
      when(() => mockRemoteSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repo.getRandomNumberTrivia();

      //asert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when remote data source is successful',
          () async {
        // arrange
        when(() => mockLocalSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async => Future.value(false));
        when(() => mockRemoteSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repo.getRandomNumberTrivia();

        // assert
        // did we call you with teh correct param?
        verify(() => mockRemoteSource.getRandomNumberTrivia()).called(1);
        // we can explicitly place it
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache data locally when the call to remote is successful',
          () async {
        when(() => mockLocalSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async => Future.value(false));
        when(() => mockRemoteSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repo.getRandomNumberTrivia();
        verify(() => mockRemoteSource.getRandomNumberTrivia()).called(1);
        verify(() => mockLocalSource.cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockLocalSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async => Future.value(false));
        when(() => mockRemoteSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repo.getRandomNumberTrivia();
        // getRandomNumberTrivia
        verify(() => mockRemoteSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when cached data is present',
          () async {
        when(() => mockLocalSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repo.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteSource);
        verify(() => mockLocalSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repo.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteSource);
        verify(() => mockLocalSource.getLastNumberTrivia()).called(1);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
