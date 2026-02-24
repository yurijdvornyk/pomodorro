import 'package:pomodorro/data/model/pomodorro_item.dart';

class HomeState {
  const HomeState({this.pomodorros = const []});

  final List<PomodorroItem> pomodorros;
  
  HomeState copyWith({
    List<PomodorroItem>? pomodorros,
  }) {
    return HomeState(
      pomodorros: pomodorros ?? this.pomodorros,
    );
  }
}
