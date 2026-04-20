import 'dart:async';

import 'package:pomodorro/model/pom_timeline.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/data/service/pom_db_service.dart';

class PomRepository {
  final PomDbService _dbService;

  PomRepository(this._dbService);

  Future<void> initializeDatabase() {
    return _dbService.initializeDb();
  }

  Future<List<PomodorroItem>> fetchPomodorros() {
    return _dbService.getPomodorros();
  }

  Future<PomodorroItem?> getPomodorroById(int id) {
    return _dbService.getPomodorroById(id);
  }

  Future<PomodorroItem> savePomodorro({
    int? id,
    String? title,
    required int concentrationMinutes,
    required int relaxationMinutes,
    required int cyclesCount,
  }) {
    return _dbService.savePomodorro(
      id: id,
      title: title,
      concentrationMinutes: concentrationMinutes,
      relaxationMinutes: relaxationMinutes,
      cyclesCount: cyclesCount,
    );
  }

  Future<PomTimeline> createPomodorroTimeline(PomodorroItem item) async {
    final timeline = PomTimeline(pomItemId: item.id!, sections: []);
    for (int i = 0; i < item.cyclesCount; i++) {
      timeline.sections.add(
        PomTimelineSection(
          sectionType: PomTimelineSectionType.concentration,
          durationMinutes: item.concentrationMinutes,
        ),
      );
      if (i < item.cyclesCount - 1) {
        timeline.sections.add(
          PomTimelineSection(
            sectionType: PomTimelineSectionType.relax,
            durationMinutes: item.relaxMinutes,
          ),
        );
      }
    }
    return timeline;
  }
}
