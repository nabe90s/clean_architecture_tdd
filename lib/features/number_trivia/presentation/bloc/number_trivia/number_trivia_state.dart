import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object?> get props => [];
}

class Empty extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia});

  @override
  List<Object?> get props => [trivia];

  @override
  String toString() {
    return 'Loaded { trivia: $trivia }';
  }
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message});

  @override
  String toString() {
    return 'Error { message: $message }';
  }
}
