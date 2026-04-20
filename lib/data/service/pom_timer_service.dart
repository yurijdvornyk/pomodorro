import 'package:pomodorro/model/pom_timeline.dart';

abstract class PomTimerService {
  final PomTimeline timeline;

  Stream<PomTimelineState> get timelineStream;

  const PomTimerService({required this.timeline});

  void startTimer();

  void pauseTimer();

  void resetTimer();
}
