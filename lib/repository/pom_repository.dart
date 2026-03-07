import 'dart:async';

import 'package:pomodorro/data/model/pomodorro_item.dart';
import 'package:pomodorro/data/service/pom_db_service.dart';

class PomRepository {
  final PomDbService _dbService;

  PomRepository(this._dbService);

  Future<void> initializeDatabase() {
    return _dbService.initializeDb();
  }

  Future<List<PomodorroItem>> fetchPomodorros() {
    return _dbService.getPomodorros();
  }
}
