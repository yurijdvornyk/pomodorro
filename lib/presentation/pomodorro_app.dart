import 'package:flutter/material.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/presentation/details/details_page.dart';
import 'package:pomodorro/presentation/play/play_page.dart';

import 'home/home_page.dart';

class PomodorroApp extends StatefulWidget {
  const PomodorroApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<PomodorroApp> {
  final pomRepository = PomDependencyInjector.instance.pomRepository;

  @override
  void initState() {
    super.initState();
    pomRepository.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodorro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoute.home.routeName,
      routes: appRoutingMap,
    );
  }
}

enum AppRoute { home, details, play }

extension AppRouteName on AppRoute {
  String get routeName {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.details:
        return '/details';
      case AppRoute.play:
        return '/play';
    }
  }
}

Map<String, Widget Function(BuildContext)> get appRoutingMap => {
  AppRoute.home.routeName: (context) => HomePage(),
  AppRoute.details.routeName: (context) => DetailsPage(),
  AppRoute.play.routeName: (context) => PlayPage(),
};
