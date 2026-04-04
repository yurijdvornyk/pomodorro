import 'package:flutter/material.dart';
import 'package:pomodorro/common/dependencies/injector.dart';

import 'home/home_page.dart';

class PomodorroApp extends StatelessWidget {
  PomodorroApp({super.key});

  final PomDependencyInjector _injector = PomDependencyInjector();

  @override
  Widget build(BuildContext context) {
    final pomRepository = _injector.pomRepository;
    return FutureBuilder(
      future: pomRepository.initializeDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Pomodorro',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => HomePage(),
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
