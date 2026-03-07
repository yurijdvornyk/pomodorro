import 'package:pomodorro/data/db/pom_db.dart';
import 'package:sqlite3/sqlite3.dart';

class PomDbMobile implements PomDb {
  Database? _db;

  PomDbMobile();

  @override
  Future<void> open() async {
    _db ??= sqlite3.open('pomodorro.db');
  }

  @override
  Future<void> close() async {
    _db?.close();
    _db = null;
  }

  Database get database {
    if (_db != null) {
      return _db!;
    } else {
      throw StateError('Database not opened');
    }
  }
}