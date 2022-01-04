class ReportHistory {
  final String status;
  final String description;
  final String createdAt;

  ReportHistory({
    this.status,
    this.description,
    this.createdAt,
  });

  factory ReportHistory.fromJson(Map<String, dynamic> json) {
    return ReportHistory(
      status: json['status_progress'] ?? '',
      description: json['keterangan'] ?? '<p></p>',
      createdAt: json['tanggal'] ?? '',
    );
  }
}
