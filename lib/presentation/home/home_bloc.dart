import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/presentation/base_bloc.dart';
import 'package:pomodorro/model/pomodorro_item.dart';

class HomeBloc extends PBloc<HomeState, HomeEvent> {
  final _repository = PomDependencyInjector.instance.pomRepository;

  @override
  HomeState get initialState => HomeState();

  @override
  void start() {
    super.start();
    _repository.fetchPomodorros().then(
      (poms) => emitState(HomeState(pomodorros: poms)),
    );
  }

  @override
  void onEvent(HomeEvent event) {
  }
}

class HomeState {
  final List<PomodorroItem> pomodorros;

  const HomeState({
    this.pomodorros = const [],
  });

  HomeState copyWith({
    PomodorroItem? editingItem,
    List<PomodorroItem>? pomodorros,
  }) {
    return HomeState(
      pomodorros: pomodorros ?? this.pomodorros,
    );
  }
}

abstract class HomeEvent {}