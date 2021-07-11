import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia/number_trivia_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
])
void main() {
  late NumberTriviaBloc bloc;
  late GetConcreteNumberTrivia getConcreteNumberTrivia;
  late GetRandomNumberTrivia getRandomNumberTrivia;
  late InputConverter inputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter);
  });

  test('initialState should be empty', () {
    // arrange
    // action
    // assert
    expect(bloc.state, equals(Empty()));
  });
}
