import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPref extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPref mockSharedPref;

  setUp(() {
    mockSharedPref = MockSharedPref();
    dataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPref);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should return NumberTrivia from SharedPref when there is one cached',
        () async {
      when(() => mockSharedPref.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(() => mockSharedPref.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a cacheexception when there is no cached value',
        () async {
      when(() => mockSharedPref.getString(any())).thenReturn(null);

      // act
      // store the method inside call var
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(() => mockSharedPref.setString(any(), any()))
            .thenAnswer((_) async => Future.value(false));
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSharedPref.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            ));
      },
    );
  });
}
