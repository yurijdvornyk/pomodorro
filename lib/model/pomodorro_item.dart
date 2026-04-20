import 'package:pomodorro/model/pom_mappable.dart';

class PomodorroItem implements PomMappable {
  final int? id;
  final String title;
  final int concentrationMinutes;
  final int relaxMinutes;
  final int cyclesCount;

  int get totalMinutes => (concentrationMinutes + relaxMinutes) * cyclesCount;

  const PomodorroItem({
    required this.id,
    required this.title,
    this.concentrationMinutes = 25,
    this.relaxMinutes = 5,
    this.cyclesCount = 4,
  });

  PomodorroItem copyWith({
    int? id,
    String? title,
    int? concentrationMinutes,
    int? relaxMinutes,
    int? cyclesCount,
  }) {
    return PomodorroItem(
      id: id ?? this.id,
      title: title ?? this.title,
      concentrationMinutes: concentrationMinutes ?? this.concentrationMinutes,
      relaxMinutes: relaxMinutes ?? this.relaxMinutes,
      cyclesCount: cyclesCount ?? this.cyclesCount,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'concentrationMinutes': concentrationMinutes,
      'relaxationMinutes': relaxMinutes,
      'cyclesCount': cyclesCount,
    };
  }

  @override
  factory PomodorroItem.fromMap(Map<String, Object?> map) {
    return PomodorroItem(
      id: map['id'] as int,
      title: map['title'] as String,
      concentrationMinutes: map['concentrationMinutes'] as int,
      relaxMinutes: map['relaxationMinutes'] as int,
      cyclesCount: map['cyclesCount'] as int,
    );
  }
}
