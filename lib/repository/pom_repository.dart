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
    return _dbService.getPomodorros();
  }

  Future<PomodorroItem> savePomodorro({
    String? title,
    required int concentrationMinutes,
    required int relaxationMinutes,
    required int cyclesCount,
  }) {
    return Future.delayed(const Duration(milliseconds: 1000), () {
      return PomodorroItem(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title ?? "Untitled Pomodorro",
        concentrationMinutes: concentrationMinutes,
        relaxationMinutes: relaxationMinutes,
        cyclesCount: cyclesCount,
      );
    });
    // return _dbService.savePomodorro(
    //   title: title,
    //   concentrationMinutes: concentrationMinutes,
    //   relaxationMinutes: relaxationMinutes,
    //   cyclesCount: cyclesCount,
    // );
  }
}
