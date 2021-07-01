import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exception.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([
  SharedPreferences,
])
void main() {
  late SharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'))
          .thenAnswer((_) => fixture('trivia_cached.json'));
      // action
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, tNumberTriviaModel);
    });
    // test(
    //     'should return NumberTrivia from SharedPreferences when there is not a cache',
    //     () async {
    //   // arrange
    //   when(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'))
    //       .thenAnswer((_) => '');
    //   // action
    //   final call = dataSource.getLastNumberTrivia;
    //   // assert
    //   expect(()=> call(), throwsA(TypeMatcher<CacheException>()));
    // });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () {
      // arrange
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      when(mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA, expectedJsonString))
          .thenAnswer((_) => Future.value(true));
      // action;
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
