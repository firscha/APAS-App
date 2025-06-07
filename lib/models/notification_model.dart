class NotificationModel {
  final String category;
  final String title;
  final String description;
  final DateTime timestamp;

  NotificationModel({
    required this.category,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}