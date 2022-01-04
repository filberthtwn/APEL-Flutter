class DocHistory {
  final String status;
  final String description;
  final String createdAt;

  DocHistory({
    this.status,
    this.description,
    this.createdAt,
  });

  factory DocHistory.fromJson(Map<String, dynamic> json) {
    return DocHistory(
      status: json['status_berkas'] ?? '',
      description: json['log_description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
