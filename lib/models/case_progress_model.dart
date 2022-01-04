class CaseProgress {
  final String id;
  final String name;
  // final String createdAt;

  CaseProgress({
    this.id,
    this.name,
    // this.createdAt,
  });

  factory CaseProgress.fromJson(Map<String, dynamic> json) {
    return CaseProgress(
      id: json['id'] ?? '',
      name: json['nama_progress'] ?? '',
      // createdAt: json['created_at'] ?? '',
    );
  }
}
