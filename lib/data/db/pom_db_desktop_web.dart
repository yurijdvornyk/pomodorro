import 'package:pomodorro/data/db/pom_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/services.dart' show rootBundle;

class PomDbDesktopWeb implements PomDb {
  Database get database {
    if (_db != null) {
      return _db!;
    } else {
      throw StateError('Database not opened');
    }
  }

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

  @override
  Future<void> initialize() async {
    final script = await rootBundle.loadString('assets/sql/schema.sql');
    await open();
    await database.execute(script);
  }

  @override
  Future<void> delete() async {
    await databaseFactory.deleteDatabase('pomodorro.db');
  }

  @override
  Future<void> insertRecords(
    String tableName,
    Map<String, Object?> values,
  ) async {
    await database.insert(tableName, values);
  }

  @override
  Future<void> updateRecords(
    String tableName,
    Map<String, Object?> values,
    String where,
    List<Object?> whereArgs,
  ) async {
    await database.update(
      tableName,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<void> deleteRecords(
    String tableName,
    String where,
    List<Object?> whereArgs,
  ) async {
    await database.delete(tableName, where: where, whereArgs: whereArgs);
  }

  @override
  Future<Object?> findRecordById(String tableName, int id) async {
    List<Object> records = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return records.isNotEmpty ? records.first : null;
  }

  @override
  Future<List<Map<String, Object?>>> getRecords(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await database.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }
}
