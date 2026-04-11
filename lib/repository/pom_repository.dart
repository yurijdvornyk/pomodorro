import 'dart:async';

import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/data/service/pom_db_service.dart';

class PomRepository {
  final PomDbService _dbService;

  PomRepository(this._dbService);

  Future<void> initializeDatabase() {
    return _dbService.initializeDb();
  }

  Future<List<PomodorroItem>> fetchPomodorros() {
    // return _dbService.getPomodorros();
    return Future.delayed(
      Duration(seconds: 1),
      () => [
        PomodorroItem(
          id: 1,
          title: "Study Session",
          concentrationMinutes: 25,
          relaxationMinutes: 5,
          cyclesCount: 4,
        ),
        PomodorroItem(
          id: 2,
          title: "Work Session",
          concentrationMinutes: 50,
          relaxationMinutes: 10,
          cyclesCount: 2,
        ),
      ],
    );
  }

  Future<PomodorroItem> savePomodorro({
    String? title,
    required int concentrationMinutes,
    required int relaxationMinutes,
    required int cyclesCount,
  }) {
    return _dbService.savePomodorro(
      title: title,
      concentrationMinutes: concentrationMinutes,
      relaxationMinutes: relaxationMinutes,
      cyclesCount: cyclesCount,
    );
  }
}
