class Report {
  final String id;
  final String listingId;
  final String listingTitle;
  final String reporterName;
  final String reason;
  final String details;
  final DateTime createdAt;
  final String status; // 'pending', 'resolved', 'dismissed'

  Report({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.reporterName,
    required this.reason,
    required this.details,
    required this.createdAt,
    this.status = 'pending',
  });

  Report copyWith({
    String? id,
    String? listingId,
    String? listingTitle,
    String? reporterName,
    String? reason,
    String? details,
    DateTime? createdAt,
    String? status,
  }) {
    return Report(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      listingTitle: listingTitle ?? this.listingTitle,
      reporterName: reporterName ?? this.reporterName,
      reason: reason ?? this.reason,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
