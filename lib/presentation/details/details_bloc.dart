import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/base.dart';
import 'package:pomodorro/repository/pom_repository.dart';

class DetailsBloc extends PBloc<EditState, DetailsEvent> {
  final PomRepository _repository =
      PomDependencyInjector.instance.pomRepository;

  final PomodorroItem? _editingItem;

  DetailsBloc({PomodorroItem? editingItem}) : _editingItem = editingItem;

  @override
  EditState get initialState =>
      _editingItem != null
          ? EditState(
            mode: DetailsMode.edit,
            id: _editingItem.id,
            title: _editingItem.title,
            concentration: _editingItem.concentrationMinutes,
            relax: _editingItem.relaxMinutes,
            cycles: _editingItem.cyclesCount,
          )
          : EditState(mode: DetailsMode.create);

  @override
  void onEvent(DetailsEvent event) {
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
        _repository
            .savePomodorro(
              id: currentState.id,
              title: currentState.title,
              concentrationMinutes: currentState.concentration,
              relaxationMinutes: currentState.relax,
              cyclesCount: currentState.cycles,
            )
            .then(
              (savedItem) => emitState(currentState.copyWith(
                id: savedItem.id,
                title: savedItem.title,
                concentration: savedItem.concentrationMinutes,
                relax: savedItem.relaxMinutes,
                cycles: savedItem.cyclesCount,
              )),
            );
      } else {
        throw StateError("Title cannot be empty");
      }
    }
  }
}

enum DetailsMode { create, edit }

abstract class DetailsEvent {}

class UpdateTitleEvent implements DetailsEvent {
  final String title;

  UpdateTitleEvent(this.title);
}

class UpdateConcentrationEvent implements DetailsEvent {
  final int concentration;

  UpdateConcentrationEvent(this.concentration);
}

class UpdateRelaxEvent implements DetailsEvent {
  final int relax;

  UpdateRelaxEvent(this.relax);
}

class UpdateCyclesEvent implements DetailsEvent {
  final int cycles;

  UpdateCyclesEvent(this.cycles);
}

class SaveEvent implements DetailsEvent {}

class EditState {
  final DetailsMode mode;
  final int? id;
  final String? title;
  final int concentration;
  final int relax;
  final int cycles;

  EditState({
    this.mode = DetailsMode.create,
    this.id,
    this.title,
    this.concentration = 25,
    this.relax = 5,
    this.cycles = 2,
  });

  EditState copyWith({
    DetailsMode? mode,
    int? id,
    String? title,
    int? concentration,
    int? relax,
    int? cycles,
  }) {
    return EditState(
      mode: mode ?? this.mode,
      id: id ?? this.id,
      title: title ?? this.title,
      concentration: concentration ?? this.concentration,
      relax: relax ?? this.relax,
      cycles: cycles ?? this.cycles,
    );
  }

  bool get isPlayable => id != null && title?.isNotEmpty == true;
}
