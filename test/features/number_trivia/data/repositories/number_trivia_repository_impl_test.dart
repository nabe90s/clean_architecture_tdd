import 'package:clean_architecture_tdd/core/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late NumberTriviaRemoteDataSource remote;
  late NumberTriviaLocalDataSource local;
  late NetworkInfo networkInfo;

  setUp(() {
    remote = MockNumberTriviaRemoteDataSource();
    local = MockNumberTriviaLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
      networkInfo: networkInfo,
    );
  });
}
