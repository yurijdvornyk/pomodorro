import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/base.dart';

class PlayBloc extends PBloc<PlayState, PlayEvent> {
  late final PomodorroItem? pomItem;

  PlayBloc();

  @override
  PlayState get initialState => PlayState();

  @override
  void onEvent(PlayEvent event) {
    if (event is PomodorroSetEvent) {
      pomItem = event.pomItem;
    } else if (event is StartPomEvent) {
      emitState(currentState.copyWith(isPlaying: true));
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
  final bool isPlaying;
  final int currentPosition;

  PlayState({this.isPlaying = false, this.currentPosition = 0});

  PlayState copyWith({bool? isPlaying, int? currentPosition}) {
    return PlayState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }
}
