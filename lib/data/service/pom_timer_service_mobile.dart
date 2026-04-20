import 'package:pomodorro/data/service/pom_timer_service.dart';
import 'package:pomodorro/model/pom_timeline.dart';

class PomTimerServiceMobile extends PomTimerService {
  PomTimerServiceMobile({required super.timeline});

  @override
  Stream<PomTimelineState> get timelineStream => throw UnimplementedError();

  @override
  void pauseTimer() {
    // TODO: implement pauseTimer
  }

  @override
  void resetTimer() {
    // TODO: implement resetTimer
  }

  @override
  void startTimer() {
    // TODO: implement startTimer
  }
}
