import 'package:pomodorro/presentation/base_bloc.dart';
import 'package:pomodorro/data/model/pomodorro_item.dart';
import 'package:pomodorro/repository/pom_repository.dart';

class HomeBloc extends PBloc<HomeState, HomeEvent> {
  final PomRepository _pomRepository;

  HomeBloc({required PomRepository pomRepository})
    : _pomRepository = pomRepository;

  @override
  void start() {
    super.start();
    _pomRepository.fetchPomodorros().then((poms) {
      emitState(HomeState(pomodorros: poms));
    });
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

class ItemTappedEvent implements HomeEvent {
  final PomodorroItem item;

  ItemTappedEvent({required this.item});
}
