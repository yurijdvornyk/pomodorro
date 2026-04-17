class PomTimeline {
  final List<PomTimelineSection> sections;

  int totalDurationSeconds() {
    return sections.fold(0, (total, section) => total + section.durationMinutes * 60);
  }

  PomTimeline({required this.sections});
}

enum PomTimelineSectionType { concentration, relax }

class PomTimelineSection {
  final PomTimelineSectionType sectionType;
  final int durationMinutes;

  PomTimelineSection({required this.sectionType, required this.durationMinutes});
}
