import 'package:clean_architecture_tdd/core/error/exception.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late NumberTriviaRemoteDataSource mockRemoteDataSource;
  late NumberTriviaLocalDataSource mockLocalDataSource;
  late NetworkInfo mockNetworkInfo;

  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel(text: 'test trivia', number: tNumber);
  final NumberTrivia tNumberTrivia = tNumberTriviaModel;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => tNumberTriviaModel);
  });

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      // action
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('device is online', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      // action
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTrivia)));
    });

    test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
      // arrange
      // action
      await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenThrow(ServerException());
      // action
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
        'should return last locally cached data when the cached data is present',
        () async {
      // arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      // action
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTriviaModel)));
    });

    test('should return CacheFailure when there is no cached data present',
        () async {
      // arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
      // action
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, Left(CacheFailure()));
    });
  });
}
