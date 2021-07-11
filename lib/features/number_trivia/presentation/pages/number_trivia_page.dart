import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_trivia/number_trivia_bloc.dart';

// Uncomment if you use injector package.
// import 'package:my_app/framework/di/injector.dart';

class NumberTrivia extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return NumberTriviaState();
  }
}

class NumberTriviaState extends State<NumberTrivia> {

  // Insert into injector file if you use it.
  // injector.map<NumberTriviaBloc>((i) => NumberTriviaBloc(i.get<Repository>()), isSingleton: true);

  // Uncomment if you use injector.
  // final _bloc = injector.get<NumberTriviaBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}