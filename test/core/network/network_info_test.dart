import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/network/network_info.dart';

import '../../features/number_trivia/data/data_sources/number_trivia_local_data_source_test.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}


void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group(('isConnected'), () {
    test(
        'should forward the call to mockInternetConnectionChecker.hasConnection',
        () async {
      // arrange
      // bool result = await InternetConnectionChecker().hasConnection;
      final tHasConnectionFuture = Future.value(true);
      when(() => mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      // act
      // we are not awaiting the result
      // InternetConnectionChecker
      final result = networkInfo.isConnected;

      //assert
      verify(() => mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });


  });
}
