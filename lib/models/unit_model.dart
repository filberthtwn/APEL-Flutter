class Unit {
  final String id;
  final String name;

  Unit({
    this.id,
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] ?? '',
      name: json['nama_unit'] ?? '',
    );
  }
}
