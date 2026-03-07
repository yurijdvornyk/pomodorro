import 'package:flutter/material.dart';
import 'package:pomodorro/data/service/pom_db_service.dart';
import 'package:pomodorro/repository/pom_repository.dart';

import 'home/home_bloc.dart';
import 'home/home_page.dart';

class PomodorroApp extends StatelessWidget {
  PomodorroApp({super.key});

  final PomRepository _pomRepository = PomRepository(PomDbService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pomRepository.initializeDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Pomodorro',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: HomePage(homeBloc: HomeBloc(pomRepository: _pomRepository)),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
