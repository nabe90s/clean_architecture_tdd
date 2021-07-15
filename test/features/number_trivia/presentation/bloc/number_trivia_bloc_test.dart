import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart'
    as c;
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia/number_trivia_event.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  c.GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
])
void main() {
  late NumberTriviaBloc bloc;
  late c.GetConcreteNumberTrivia getConcreteNumberTrivia;
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

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loading, Loaded] when getting data success',
        build: () {
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(Right(tNumberParsed));
          when(getConcreteNumberTrivia.call(c.Params(number: tNumberParsed)))
              .thenAnswer((_) async => Right(tNumberTrivia));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [
              Loading(),
              Loaded(trivia: tNumberTrivia),
            ],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
        });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loading, Error] when getting data fails ServerFailure',
        build: () {
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(Right(tNumberParsed));
          when(getConcreteNumberTrivia.call(c.Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [
              Loading(),
              Error(message: SERVER_FAILURE_MESSAGE),
            ],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
        });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loading, Error] when getting data fails CacheFailure',
        build: () {
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(Right(tNumberParsed));
          when(getConcreteNumberTrivia.call(c.Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(CacheFailure()));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [
              Loading(),
              Error(message: CACHE_FAILURE_MESSAGE),
            ],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
        });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Error] when the input is invalid',
        build: () {
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(Left(InvalidInputFailure()));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
        });
  });



  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loading, Loaded] when getting data success',
        build: () {
          when(getRandomNumberTrivia.call(NoParams()))
              .thenAnswer((_) async => Right(tNumberTrivia));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loading, Error] when getting data fails ServerFailure',
        build: () {
          when(getRandomNumberTrivia.call(NoParams()))
              .thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Loading, Error] when getting data fails CacheFailure',
        build: () {
          when(getRandomNumberTrivia.call(NoParams()))
              .thenAnswer((_) async => Left(CacheFailure()));
          return bloc;
        },
        act: (bloc) async =>
            bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ],
    );
  });
}
