import 'package:flutter/material.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/presentation/details/details_page.dart';

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
            initialRoute: AppRoute.home.routeName,
            routes: appRoutingMap,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

enum AppRoute { home, details }

extension AppRouteName on AppRoute {
  String get routeName {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.details:
        return '/details';
    }
  }
}

Map<String, Widget Function(BuildContext)> get appRoutingMap => {
  AppRoute.home.routeName: (context) => HomePage(),
  AppRoute.details.routeName: (context) => DetailsPage(),
};
