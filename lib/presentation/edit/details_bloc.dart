import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/base_bloc.dart';
import 'package:pomodorro/repository/pom_repository.dart';

class DetailsBloc extends PBloc<EditState, EditEvent> {

  final PomRepository _repository = PomDependencyInjector.instance.pomRepository;

  final PomodorroItem? _editingItem;

  DetailsBloc({PomodorroItem? editingItem}) : _editingItem = editingItem;

  @override
  EditState get initialState =>
      _editingItem != null
          ? EditState(
            title: _editingItem.title,
            concentration: _editingItem.concentrationMinutes,
            relax: _editingItem.relaxationMinutes,
            cycles: _editingItem.cyclesCount,
          )
          : EditState();

  @override
  void onEvent(EditEvent event) {
    if (event is UpdateTitleEvent) {
      emitState(currentState.copyWith(title: event.title));
    } else if (event is UpdateConcentrationEvent) {
      emitState(currentState.copyWith(concentration: event.concentration));
    } else if (event is UpdateRelaxEvent) {
      emitState(currentState.copyWith(relax: event.relax));
    } else if (event is UpdateCyclesEvent) {
      emitState(currentState.copyWith(cycles: event.cycles));
    } else if (event is SaveEvent) {
      if (currentState.title != null) {
        _repository.savePomodorro(
          title: currentState.title,
          concentrationMinutes: currentState.concentration,
          relaxationMinutes: currentState.relax,
          cyclesCount: currentState.cycles,
        );
      } else {
        throw StateError("Title cannot be empty");
      }
    }
  }
}

enum DetailsMode {
  create,
  edit,
}

abstract class EditEvent {}

class UpdateTitleEvent implements EditEvent {
  final String title;

  UpdateTitleEvent(this.title);
}

class UpdateConcentrationEvent implements EditEvent {
  final int concentration;

  UpdateConcentrationEvent(this.concentration);
}

class UpdateRelaxEvent implements EditEvent {
  final int relax;

  UpdateRelaxEvent(this.relax);
}

class UpdateCyclesEvent implements EditEvent {
  final int cycles;

  UpdateCyclesEvent(this.cycles);
}

class SaveEvent implements EditEvent {}

class EditState {
  final DetailsMode mode;
  final String? title;
  final int concentration;
  final int relax;
  final int cycles;

  EditState({
    this.mode = DetailsMode.create,
    this.title,
    this.concentration = 25,
    this.relax = 5,
    this.cycles = 2,
  });

  EditState copyWith({
    String? title,
    int? concentration,
    int? relax,
    int? cycles,
  }) {
    return EditState(
      title: title ?? this.title,
      concentration: concentration ?? this.concentration,
      relax: relax ?? this.relax,
      cycles: cycles ?? this.cycles,
    );
  }
}
