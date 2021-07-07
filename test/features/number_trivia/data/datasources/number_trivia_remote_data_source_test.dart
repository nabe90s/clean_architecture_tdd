import 'dart:convert';

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

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final uri = Uri.parse('http://numbersapi.com/$tNumber');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final tHeader = {'Content-Type': 'application/json'};
    test(
        'should perform a GET request on a URL with being the endpoint and with application/json header',
        () {
      // arrange
      when(mockClient.get(uri, headers: tHeader))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      // action
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
          mockClient.get(uri, headers: {'Content-Type': 'application/json'}));
    });
    test('should return NumberTrivia when the response code is 200(success)',
        () async {
      // arrange
      when(mockClient.get(uri, headers: tHeader)).thenAnswer(
          (realInvocation) async => http.Response(fixture('trivia.json'), 200));
      // action
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });
  });
}
