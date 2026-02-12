enum LogCategory { security, environment, system }
enum LogSeverity { info, warning, critical }

class ActivityLogModel {
  final String id;
  final DateTime timestamp;
  final LogCategory category;
  final LogSeverity severity;
  final String title;
  final String description;

  const ActivityLogModel({
    required this.id,
    required this.timestamp,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
  });
}
