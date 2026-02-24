import 'package:flutter/material.dart';

import 'home/home_page.dart';

class PomodorroApp extends StatelessWidget {
  const PomodorroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}