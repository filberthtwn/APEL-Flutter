class Region {
  final String id;
  final String regionCode;
  final String name;

  Region({
    this.id,
    this.regionCode,
    this.name,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? '',
      regionCode: json['kode_wilayah'] ?? '',
      name: json['nama_wilayah'] ?? '',
    );
  }
}
