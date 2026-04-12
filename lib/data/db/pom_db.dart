import 'package:pomodorro/common/platform_check.dart';
import 'package:pomodorro/data/db/pom_db_desktop_web.dart';
import 'package:pomodorro/data/db/pom_db_mobile_mac.dart';

abstract class PomDb {
  factory PomDb() => _getInstance();

  Future<void> open();

  Future<void> close();

  Future<void> delete();

  Future<void> initialize();

  Future<Object?> findRecordById(String tableName, int id);

  Future<List<Map<String, Object?>>> getRecords(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> insertRecord(
    String tableName,
    Map<String, Object?> values,
    PomDbConflictAlgorithm conflictAlgorithm,
  );

  Future<void> updateRecords(
    String tableName,
    Map<String, Object?> values,
    String where,
    List<Object?> whereArgs,
  );

  Future<void> deleteRecords(
    String tableName,
    String where,
    List<Object?> whereArgs,
  );
}

PomDb? _instance;

PomDb _getInstance() {
  if (_instance == null) {
    if (isMobileOrAppleDesktop) {
      _instance = PomDbMobile();
    } else if (isWeb || isDesktop) {
      _instance = PomDbDesktopWeb();
    } else {
      throw UnsupportedError('Platform is not supported by PomDb');
    }
  }
  return _instance!;
}

enum PomDbConflictAlgorithm { replace, error, ignore }
