import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pomodorro/data/db/pom_db.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:flutter/services.dart' show rootBundle;

class PomDbMobile implements PomDb {
  Database get database {
    if (_db != null) {
      return _db!;
    } else {
      throw StateError('Database not opened');
    }
  }

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

  @override
  Future<void> initialize() async {
    final script = await rootBundle.loadString('assets/sql/schema.sql');
    await open();
     try {
      database.execute(script);
    } catch (e) {
      _catchDbError(e);
    }
  }

  @override
  Future<void> delete() async {
    final file = File('pomodorro.db');
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  @override
  Future<void> deleteRecords(
    String tableName,
    String where,
    List<Object?> whereArgs,
  ) async {
    try {
      _db?.execute('DELETE FROM $tableName WHERE $where', whereArgs);
    } catch (e) {
      _catchDbError(e);
    }
  }

  @override
  Future<Object?> findRecordById(String tableName, int id) async {
    try {
      final query = 'SELECT * FROM $tableName WHERE id = ? LIMIT 1';
      final resultSet = _db?.select(query, [id]);
      if (resultSet != null && resultSet.isNotEmpty) {
        return resultSet.first;
      }
    } catch (e) {
      _catchDbError(e);
    }
    return null;
  }

  @override
  Future<List<Map<String, Object?>>> getRecords(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final query =
          'SELECT * FROM $tableName${where != null ? ' WHERE $where' : ''}';
      final resultSet = _db?.select(query, whereArgs ?? []);
      final columnsCount = resultSet?.columnNames.length ?? 0;
      final List<Map<String, Object?>> result = [];
      for (final row in resultSet?.rows ?? []) {
        final Map<String, Object?> record = {};
        for (int i = 0; i < columnsCount; i++) {
          final columnName = resultSet?.columnNames[i] ?? '';
          record[columnName] = row[i];
        }
        result.add(record);
      }
      return result;
    } catch (e) {
      if (_db == null) {
        throw StateError('Database not opened');
      } else {
        throw Exception('Error querying records: $e');
      }
    }
  }

  @override
  Future<int> insertRecord(
    String tableName,
    Map<String, Object?> values,
    PomDbConflictAlgorithm conflictAlgorithm,
  ) async {
    try {
      final columns = values.keys.join(', ');
      final placeholders = List.filled(values.length, '?').join(', ');
      final String prefix;
      if (conflictAlgorithm == PomDbConflictAlgorithm.replace) {
        prefix = "INSERT";
      } else if (conflictAlgorithm == PomDbConflictAlgorithm.replace) {
        prefix = "INSERT OR REPLACE";
      } else {
        return -1;
      }
      final query = '$prefix INTO $tableName ($columns) VALUES ($placeholders)';
      _db?.execute(query, values.values.toList());
      return _db?.lastInsertRowId ?? 0;
    } catch (e) {
      _catchDbError(e);
      return -1; // Return -1 to indicate failure
    }
  }

  @override
  Future<void> updateRecords(
    String tableName,
    Map<String, Object?> values,
    String where,
    List<Object?> whereArgs,
  ) async {
    try {
      final setClause = values.keys.map((key) => '$key = ?').join(', ');
      final query = 'UPDATE $tableName SET $setClause WHERE $where';
      _db?.execute(query, [...values.values, ...whereArgs]);
    } catch (e) {
      _catchDbError(e);
    }
  }

  void _catchDbError(Object e) {
    if (_db == null) {
      throw StateError('Database not opened');
    } else {
      throw Exception('Database error: $e');
    }
  }
}
