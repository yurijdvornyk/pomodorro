import 'package:pomodorro/data/db/pom_db.dart';
import 'package:pomodorro/data/model/pomodorro_item.dart';

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
}
