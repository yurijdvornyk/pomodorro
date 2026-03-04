import 'package:flutter/material.dart';
import 'package:pomodorro/repository/pom_repository.dart';

import 'home/home_bloc.dart';
import 'home/home_page.dart';

class PomodorroApp extends StatelessWidget {
  PomodorroApp({super.key});

  final PomRepository _pomRepository = PomRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodorro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(homeBloc: HomeBloc(pomRepository: _pomRepository)),
    );
  }
}
