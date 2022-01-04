class Notif {
  final String notificationId;
  final String headline;
  final String subHeadline;
  final String receiverName;
  final String receiverType;
  final String notificationType;
  final String redFlagId;
  final String redFlagType;
  final String readAt;
  final String createdAt;

  Notif({
    this.notificationId,
    this.headline,
    this.subHeadline,
    this.receiverName,
    this.receiverType,
    this.notificationType,
    this.redFlagId,
    this.redFlagType,
    this.readAt,
    this.createdAt,
  });

  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
      notificationId: json['notification_id'] ?? '',
      headline: json['headline'] ?? '',
      subHeadline: json['sub_headline'] ?? '<p></p>',
      receiverName: json['receiver_name'] ?? '',
      receiverType: json['receiver_type'] ?? '',
      notificationType: json['notification_type'] ?? '',
      redFlagId: json['red_flag_id'] ?? '',
      redFlagType: json['red_flag_type'] ?? '',
      readAt: json['read_at'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
//* rename attribute identifier
