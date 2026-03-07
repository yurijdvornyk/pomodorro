abstract class PomMappable {
  Map<String, Object?> toMap();

  factory PomMappable.fromMap(Map<String, Object?> map) {
    throw UnimplementedError('fromMap must be implemented by subclasses');
  }
}
