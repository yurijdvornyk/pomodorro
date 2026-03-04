import 'dart:async';

import 'package:flutter/foundation.dart';

class PBloc<State, Event> {
  final StreamController<State> _stateController = StreamController<State>();

  final StreamController<Event> _eventController = StreamController<Event>();

  Stream<State> get stateStream => _stateController.stream;

  Stream<Event> get eventStream => _eventController.stream;

  void start() {
    eventStream.listen((event) => onEvent(event));
  }

  void onEvent(Event event) {}

  void emitState(State state) {
    _stateController.sink.add(state);
  }

  void postEvent(Event event) {
    _eventController.sink.add(event);
  }

  @mustCallSuper
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
