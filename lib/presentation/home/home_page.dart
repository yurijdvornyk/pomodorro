import 'package:flutter/material.dart';
import 'package:pomodorro/presentation/home/home_bloc.dart';
import 'package:pomodorro/presentation/widgets/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required homeBloc}) : _homeBloc = homeBloc;

  final HomeBloc _homeBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget._homeBloc.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<HomeState>(
            stream: widget._homeBloc.stateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state == null) {
                return CircularProgressIndicator();
              } else if (state.pomodorros.isEmpty) {
                return Text("No pomodorros. Let's create one!");
              }
              return ListView.builder(
                itemCount: state.pomodorros.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return HomeCard(
                    title: state.pomodorros[index].title,
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
