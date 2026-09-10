class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String? listingId;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    this.listingId,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? listingId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      listingId: listingId ?? this.listingId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
