enum NotificationType {
  like,
  comment,
  follow,
  mention,
  message,
  trend,
}

class Notification {
  final String id;
  final NotificationType type;
  final String user;
  final String content;
  final DateTime timestamp;

  Notification({
    required this.id,
    required this.type,
    required this.user,
    required this.content,
    required this.timestamp,
  });
}

final List<Notification> dummyNotifications = [
  Notification(
    id: '1',
    type: NotificationType.like,
    user: 'John Doe',
    content: 'liked your post.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Notification(
    id: '2',
    type: NotificationType.comment,
    user: 'Jane Smith',
    content: 'commented on your post: "Great shot!"',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Notification(
    id: '3',
    type: NotificationType.follow,
    user: 'Peter Jones',
    content: 'started following you.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
