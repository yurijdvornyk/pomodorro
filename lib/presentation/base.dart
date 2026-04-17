import 'dart:async';
import 'package:flutter/material.dart';

abstract class PBloc<PState, Event> {
  final StreamController<PState> _stateController = StreamController<PState>();

  final StreamController<Event> _eventController = StreamController<Event>();

  Stream<PState> get stateStream => _stateController.stream;

  Stream<Event> get eventStream => _eventController.stream;

  PState? _currentState;

  PState get initialState;

  PState get currentState => _currentState ?? initialState;

  @mustCallSuper
  void start() {
    _currentState = initialState;
    eventStream.listen((event) => onEvent(event));
  }

  void onEvent(Event event);

  void emitState(PState state) {
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

extension PageArgumentGetter on State {
  T? getArgument<T>() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is T) {
      return args;
    }
    return null;
  }
}
