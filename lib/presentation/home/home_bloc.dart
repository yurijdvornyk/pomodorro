import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/presentation/base.dart';
import 'package:pomodorro/model/pomodorro_item.dart';

class HomeBloc extends PBloc<HomeState, HomeEvent> {
  final _repository = PomDependencyInjector.instance.pomRepository;

  @override
  HomeState get initialState => HomeState(isLoading: true, pomodorros: []);

  @override
  void start() {
    super.start();
    sendEvent(RefreshEvent());
  }

  @override
  void onEvent(HomeEvent event) {
    if (event is RefreshEvent) {
      emitState(currentState.copyWith(isLoading: true));
      _repository.fetchPomodorros().then(
        (poms) => emitState(HomeState(isLoading: false, pomodorros: poms)),
      );
    }
  }
}

class HomeState {
  final bool isLoading;
  final List<PomodorroItem> pomodorros;

  const HomeState({this.isLoading = true, this.pomodorros = const []});

  HomeState copyWith({
    bool? isLoading,
    PomodorroItem? editingItem,
    List<PomodorroItem>? pomodorros,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      pomodorros: pomodorros ?? this.pomodorros,
    );
  }
}

abstract class HomeEvent {}

class RefreshEvent extends HomeEvent {}
