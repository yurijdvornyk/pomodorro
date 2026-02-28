import 'dart:async';

import 'package:pomodorro/data/model/pomodorro_item.dart';

class PomRepository {
  Stream<List<PomodorroItem>> loadPoms() {
    return Stream.fromFuture(
      Future.delayed(
        Duration(milliseconds: 500),
        () => [
          PomodorroItem(id: 1, title: "Do some work"),
          PomodorroItem(id: 2, title: "Do homework"),
          PomodorroItem(id: 3, title: "Camp preparation"),
          PomodorroItem(id: 4, title: "Pay taxes"),
        ],
      ),
    );
  }
}
