import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodorro/presentation/home/home_cubit.dart';
import 'package:pomodorro/presentation/widgets/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: HomeCard(title: "Flutter Pomodorro", onTap: () { },),
          ),
        ),
      ),
    );
  }
}
