class SubRegion {
  final String id;
  final String name;

  SubRegion({
    this.id,
    this.name,
  });

  factory SubRegion.fromJson(Map<String, dynamic> json) {
    return SubRegion(
      id: json['sub_wilayah_id'] ?? '',
      name: json['nama_sub_wilayah'] ?? '',
    );
  }
}
