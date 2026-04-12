import 'package:pomodorro/data/db/pom_db.dart';
import 'package:pomodorro/model/pomodorro_item.dart';

class PomDbService {
  final PomDb _db = PomDb();

  Future<void> initializeDb() {
    return _db.initialize();
  }

  Future<List<PomodorroItem>> getPomodorros() {
    return _db
        .getRecords("POMODORROS")
        .then(
          (records) =>
              records.map((record) => PomodorroItem.fromMap(record)).toList(),
        );
  }

  Future<PomodorroItem> savePomodorro({
    int? id,
    String? title,
    required int concentrationMinutes,
    required int relaxationMinutes,
    required int cyclesCount,
  }) {
    return _db
        .insertRecord(
          "POMODORROS",
          {
            'id': id,
            'title': title,
            'concentrationMinutes': concentrationMinutes,
            'relaxationMinutes': relaxationMinutes,
            'cyclesCount': cyclesCount,
          },
          PomDbConflictAlgorithm.replace,
        )
        .then((id) {
          return PomodorroItem(
            id: id,
            title: title ?? "",
            concentrationMinutes: concentrationMinutes,
            relaxationMinutes: relaxationMinutes,
            cyclesCount: cyclesCount,
          );
        });
  }
}
