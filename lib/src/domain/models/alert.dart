class Alert {
  final DateTime timestamp;
  final AlertType type;
  final String title;
  final String? content;

  String get concurrencyStamp {
    final timeKey =
        '${timestamp.year}'
        '${timestamp.month.toString().padLeft(2, '0')}'
        '${timestamp.day.toString().padLeft(2, '0')}'
        '${timestamp.hour.toString().padLeft(2, '0')}'
        '${timestamp.minute.toString().padLeft(2, '0')}'
        '${timestamp.second.toString().padLeft(2, '0')}';

    final objectKey = '$title$content$type';

    return '$objectKey@$timeKey';
  }

  Alert({
    required this.timestamp,
    required this.type,
    required this.title,
    required this.content,
  });

  factory Alert.info(String title, String? content) => Alert(
    timestamp: DateTime.now(),
    type: AlertType.info,
    title: title,
    content: content,
  );

  factory Alert.warning(String title, String? content) => Alert(
    timestamp: DateTime.now(),
    type: AlertType.warning,
    title: title,
    content: content,
  );

  factory Alert.error(String title, String? content) => Alert(
    timestamp: DateTime.now(),
    type: AlertType.error,
    title: title,
    content: content,
  );
}

enum AlertType {
  info,
  warning,
  error,
}
