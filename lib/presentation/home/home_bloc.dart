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
    if (event is ItemTappedEvent) {
      emitState(
        currentState.copyWith(showDetailsPage: true, editingItem: event.item),
      );
    } else if (event is CreateTappedEvent) {
      emitState(currentState.copyWith(showDetailsPage: true, editingItem: null));
    }
  }
}

class HomeState {
  final bool showDetailsPage;
  final PomodorroItem? editingItem;
  final List<PomodorroItem> pomodorros;

  const HomeState({
    this.pomodorros = const [],
    this.editingItem,
    this.showDetailsPage = false,
  });

  HomeState copyWith({
    bool? showDetailsPage,
    PomodorroItem? editingItem,
    List<PomodorroItem>? pomodorros,
  }) {
    return HomeState(
      editingItem: editingItem ?? this.editingItem,
      pomodorros: pomodorros ?? this.pomodorros,
      showDetailsPage: showDetailsPage ?? this.showDetailsPage,
    );
  }
}

abstract class HomeEvent {}

class ItemTappedEvent implements HomeEvent {
  final PomodorroItem item;

  ItemTappedEvent({required this.item});
}

class CreateTappedEvent implements HomeEvent {}
