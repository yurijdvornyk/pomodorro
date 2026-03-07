import 'package:pomodorro/common/platform_check.dart';
import 'package:pomodorro/data/db/pom_db_desktop_web.dart';
import 'package:pomodorro/data/db/pom_db_mobile_mac.dart';

abstract class PomDb {
  factory PomDb() => _createInstance();

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

  Future<void> insertRecords(String tableName, Map<String, Object?> values);

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

PomDb _createInstance() {
  if (isMobileOrAppleDesktop) {
    return PomDbMobile();
  } else if (isWeb || isDesktop) {
    return PomDbDesktopWeb();
  } else {
    throw UnsupportedError('Platform is not supported by PomDb');
  }
}
