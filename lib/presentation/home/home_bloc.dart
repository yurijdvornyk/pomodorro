import 'package:flutter/widgets.dart';
import 'package:pomodorro/presentation/base_bloc.dart';
import 'package:pomodorro/data/model/pomodorro_item.dart';
import 'package:pomodorro/repository/pom_repository.dart';

class HomeBloc extends PBloc<HomeState, HomeEvent> {
  final PomRepository _pomRepository;

  HomeBloc({required PomRepository pomRepository})
    : _pomRepository = pomRepository {}

  void start() {
    _pomRepository.loadPoms().listen(
      (poms) => emitState(HomeState(pomodorros: poms)),
    );
  }
}

class HomeState {
  const HomeState({this.pomodorros = const []});

  final List<PomodorroItem> pomodorros;

  HomeState copyWith({List<PomodorroItem>? pomodorros}) {
    return HomeState(pomodorros: pomodorros ?? this.pomodorros);
  }
}

class HomeEvent {}
