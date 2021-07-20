import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: BlocProvider<NumberTriviaBloc>(
        create: (context) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Placeholder(),
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Placeholder(fallbackHeight: 40),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(child: Placeholder(fallbackHeight: 30)),
                        SizedBox(width: 10),
                        Expanded(child: Placeholder(fallbackHeight: 30)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
