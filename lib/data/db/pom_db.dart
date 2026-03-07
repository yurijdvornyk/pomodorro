import 'package:pomodorro/common/platform_check.dart';
import 'package:pomodorro/data/db/pom_db_desktop_web.dart';
import 'package:pomodorro/data/db/pom_db_mobile_mac.dart';

abstract class PomDb {
  factory PomDb() => _createInstance();
  
  Future<void> open();

  Future<void> close();

  // TODO: add other common methods such as query/insert/update/delete
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