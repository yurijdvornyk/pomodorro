import 'package:pomodorro/data/db/pom_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PomDbDesktopWeb implements PomDb {
  Database? _db;

  PomDbDesktopWeb() {
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } catch (_) {
      // on web the import will throw; in this case we rely on default factory
    }
  }

  @override
  Future<void> open() async {
    _db ??= await databaseFactory.openDatabase('pomodorro.db');
  }

  @override
  Future<void> close() async {
    await _db?.close();
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
