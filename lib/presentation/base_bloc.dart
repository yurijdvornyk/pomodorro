import 'dart:async';
import 'package:flutter/foundation.dart';

abstract class PBloc<State, Event> {
  final StreamController<State> _stateController = StreamController<State>();

  final StreamController<Event> _eventController = StreamController<Event>();

  Stream<State> get stateStream => _stateController.stream;

  Stream<Event> get eventStream => _eventController.stream;

  State? _currentState;

  State get initialState;

  State get currentState => _currentState ?? initialState;

  @mustCallSuper
  void start() {
    _currentState = initialState;
    eventStream.listen((event) => onEvent(event));
  }

  void onEvent(Event event);

  void emitState(State state) {
    _currentState = state;
    _stateController.sink.add(state);
  }

  void sendEvent(Event event) {
    _eventController.sink.add(event);
  }

  @mustCallSuper
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
