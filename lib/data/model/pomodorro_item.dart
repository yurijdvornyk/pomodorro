import 'package:pomodorro/data/model/pom_mappable.dart';

class PomodorroItem implements PomMappable {
  final int id;
  final String title;
  final int concentrationMinutes;
  final int relaxationMinutes;
  final int cyclesCount;

  const PomodorroItem({
    required this.id,
    required this.title,
    this.concentrationMinutes = 25,
    this.relaxationMinutes = 5,
    this.cyclesCount = 4,
  });

  PomodorroItem copyWith({
    int? id,
    String? title,
    int? concentrationMinutes,
    int? relaxationMinutes,
    int? cyclesCount,
  }) {
    return PomodorroItem(
      id: id ?? this.id,
      title: title ?? this.title,
      concentrationMinutes: concentrationMinutes ?? this.concentrationMinutes,
      relaxationMinutes: relaxationMinutes ?? this.relaxationMinutes,
      cyclesCount: cyclesCount ?? this.cyclesCount,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'concentrationMinutes': concentrationMinutes,
      'relaxationMinutes': relaxationMinutes,
      'cyclesCount': cyclesCount,
    };
  }

  @override
  factory PomodorroItem.fromMap(Map<String, Object?> map) {
    return PomodorroItem(
      id: map['id'] as int,
      title: map['title'] as String,
      concentrationMinutes: map['concentrationMinutes'] as int,
      relaxationMinutes: map['relaxationMinutes'] as int,
      cyclesCount: map['cyclesCount'] as int,
    );
  }
}
