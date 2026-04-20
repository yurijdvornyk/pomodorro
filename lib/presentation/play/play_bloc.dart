import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/base.dart';

class PlayBloc extends PBloc<PlayState, PlayEvent> {
  late final PomodorroItem? pomItem;

  PlayBloc();

  @override
  PlayState get initialState => PlayState(
        isRunning: false,
        currentPositionWithinSeconds: 0,
        sectionDurationSeconds: pomItem != null
            ? pomItem!.concentrationMinutes * 60
            : pomItem!.totalMinutes * 60,
        currentPosition: 0,
        totalSeconds: pomItem != null
            ? pomItem!.totalMinutes * 60
            : 25 * 60,
      );

  @override
  void onEvent(PlayEvent event) {
    if (event is PomodorroSetEvent) {
      pomItem = event.pomItem;
    } else if (event is StartPomEvent) {
      emitState(currentState.copyWith(isRunning: true));
    }
  }
}

class PlayEvent {}

class PomodorroSetEvent implements PlayEvent {
  final PomodorroItem pomItem;

  PomodorroSetEvent(this.pomItem);
}

class StartPomEvent implements PlayEvent {}

class PlayState {
  final bool isRunning;
  final int currentPositionWithinSeconds;
  final int sectionDurationSeconds;
  final int currentPosition;
  final int totalSeconds;

  PlayState({
    required this.isRunning,
    required this.currentPositionWithinSeconds,
    required this.sectionDurationSeconds,
    required this.currentPosition,
    required this.totalSeconds,
  });

  PlayState copyWith({
    bool? isRunning,
    int? currentPositionWithinSeconds,
    int? sectionDurationSeconds,
    int? currentPosition,
    int? totalSeconds,
  }) {
    return PlayState(
      isRunning: isRunning ?? this.isRunning,
      currentPositionWithinSeconds:
          currentPositionWithinSeconds ?? this.currentPositionWithinSeconds,
      sectionDurationSeconds:
          sectionDurationSeconds ?? this.sectionDurationSeconds,
      currentPosition: currentPosition ?? this.currentPosition,
      totalSeconds: totalSeconds ?? this.totalSeconds,
    );
  }
}
