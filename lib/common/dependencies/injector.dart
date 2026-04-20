import 'package:pomodorro/common/platform_check.dart';
import 'package:pomodorro/data/service/pom_db_service.dart';
import 'package:pomodorro/data/service/pom_timer_service.dart';
import 'package:pomodorro/data/service/pom_timer_service_desktop.dart';
import 'package:pomodorro/data/service/pom_timer_service_mobile.dart';
import 'package:pomodorro/model/pom_timeline.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/details/details_bloc.dart';
import 'package:pomodorro/presentation/home/home_bloc.dart';
import 'package:pomodorro/presentation/play/play_bloc.dart';
import 'package:pomodorro/repository/pom_repository.dart';

class PomDependencyInjector {
  static final PomDependencyInjector instance = PomDependencyInjector();

  static final PomDependencyInjector _instance =
      PomDependencyInjector._internal();

  factory PomDependencyInjector() {
    return _instance;
  }

  PomDependencyInjector._internal() {
    initializeDependencies();
  }

  // Add your dependencies here
  HomeBloc get homeBloc => HomeBloc();

  DetailsBloc detailsBloc(PomodorroItem? pomItem) =>
      DetailsBloc(editingItem: pomItem);

  PlayBloc get playBloc => PlayBloc();

  late final PomRepository pomRepository;

  late final PomDbService pomDbService;

  final Map<int, PomTimerService> _timerServiceCache = {};

  PomTimerService pomTimerService(PomTimeline timeline) {
    _timerServiceCache[timeline.pomItemId] ??= _createTimerService(timeline);
    return _timerServiceCache[timeline.pomItemId]!;
  }

  void initializeDependencies() {
    pomDbService = PomDbService();

    pomRepository = PomRepository(pomDbService);
  }

  PomTimerService _createTimerService(PomTimeline timeline) {
    if (isDesktop) {
      return PomTimerServiceDesktop(timeline: timeline);
    } else {
      return PomTimerServiceMobile(timeline: timeline);
    }
  }
}
