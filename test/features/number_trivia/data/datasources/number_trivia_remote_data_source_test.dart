import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exception.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSource dataSource;
  late MockClient mockClient;
  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  final tNumber = 1;
  final uriConcrete = Uri.parse('http://numbersapi.com/$tNumber');
  final uriRandom = Uri.parse('http://numbersapi.com/random');
  final tHeader = {'Content-Type': 'application/json'};
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  void setUpMockHttpClientSuccess200(Uri uri) {
    when(mockClient.get(uri, headers: tHeader))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }
  void setUpMockHttpClientFailure404(Uri uri) {
    when(mockClient.get(uri, headers: tHeader)).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    test(
        'should perform a GET request on a URL with being the endpoint and with application/json header',
            () {
          // arrange
          setUpMockHttpClientSuccess200(uriConcrete);
          // action
          dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          verify(
              mockClient.get(uriConcrete, headers: {'Content-Type': 'application/json'}));
        });
    test('should return NumberTrivia when the response code is 200(success)',
            () async {
          // arrange
          setUpMockHttpClientSuccess200(uriConcrete);
          // action
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        });
    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404(uriConcrete);
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
  group('getRandomNumberTrivia', () {
    test(
        'should perform a GET request on a URL with being the endpoint and with application/json header',
            () {
          // arrange
          setUpMockHttpClientSuccess200(uriRandom);
          // action
          dataSource.getRandomNumberTrivia();
          // assert
          verify(
              mockClient.get(uriRandom, headers: {'Content-Type': 'application/json'}));
        });
    test('should return NumberTrivia when the response code is 200(success)',
            () async {
          // arrange
          setUpMockHttpClientSuccess200(uriRandom);
          // action
          final result = await dataSource.getRandomNumberTrivia();
          // assert
          expect(result, equals(tNumberTriviaModel));
        });
    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404(uriRandom);
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
