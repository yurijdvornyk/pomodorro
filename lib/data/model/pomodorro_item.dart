class PomodorroItem {
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
}
