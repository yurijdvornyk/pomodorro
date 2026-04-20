class PomTimeline {
  final int pomItemId;

  final List<PomTimelineSection> sections;

  int totalDurationSeconds() {
    return sections.fold(
      0,
      (total, section) => total + section.durationMinutes * 60,
    );
  }

  PomTimeline({required this.pomItemId, required this.sections});
}

enum PomTimelineSectionType { concentration, relax }

class PomTimelineSection {
  final PomTimelineSectionType sectionType;
  final int durationMinutes;

  PomTimelineSection({
    required this.sectionType,
    required this.durationMinutes,
  });
}

class PomTimelineState {
  final int pomItemId;
  final PomTimelineSection section;
  final int secondsProgress;
  final int secondsProgressWithinSection;
  final int totalSeconds;
  final bool isRunning;

  PomTimelineState({
    required this.pomItemId,
    required this.section,
    required this.secondsProgress,
    required this.secondsProgressWithinSection,
    required this.totalSeconds, 
    required this.isRunning,
  });
}
