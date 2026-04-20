import 'dart:async';

import 'package:pomodorro/data/service/pom_timer_service.dart';
import 'package:pomodorro/model/pom_timeline.dart';

class PomTimerServiceDesktop extends PomTimerService {
  final StreamController<PomTimelineState> _timelineController =
      StreamController<PomTimelineState>();

  Timer? _timer;

  @override
  Stream<PomTimelineState> get timelineStream => _timelineController.stream;

  int _timerSeconds = 0;

  bool _isRunning = false;

  PomTimelineSection get _currentSection {
    int secondsCounter = 0;
    for (final section in timeline.sections) {
      secondsCounter += section.durationMinutes * 60;
      if (_timerSeconds < secondsCounter) {
        return section;
      }
    }
    return timeline.sections.last;
  }

  int get _secondsWithinSection {
    int secondsCounter = 0;
    for (final section in timeline.sections) {
      final sectionDurationSeconds = section.durationMinutes * 60;
      if (_timerSeconds < secondsCounter + sectionDurationSeconds) {
        return _timerSeconds - secondsCounter;
      }
      secondsCounter += sectionDurationSeconds;
    }
    return _timerSeconds - secondsCounter;
  }

  PomTimerServiceDesktop({required super.timeline});

  @override
  void startTimer() {
    _isRunning = true;
    _timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => _onTimerTick(),
    );
  }

  @override
  void pauseTimer() {
    _isRunning = false;
  }

  @override
  void resetTimer() {
    _isRunning = false;
    _timerSeconds = 0;

    _timelineController.add(
      PomTimelineState(
        pomItemId: timeline.pomItemId,
        section: _currentSection,
        secondsProgress: _timerSeconds,
        secondsProgressWithinSection: _secondsWithinSection,
        totalSeconds: timeline.totalDurationSeconds(),
        isRunning: _isRunning,
      ),
    );
  }

  void _onTimerTick() {
    if (!_isRunning) {
      return;
    }
    _timerSeconds++;
    _timelineController.add(
      PomTimelineState(
        pomItemId: timeline.pomItemId,
        section: _currentSection,
        secondsProgress: _timerSeconds,
        secondsProgressWithinSection: _secondsWithinSection,
        totalSeconds: timeline.totalDurationSeconds(),
        isRunning: _isRunning,
      ),
    );
  }
}
