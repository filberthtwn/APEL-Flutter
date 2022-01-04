class Attention {
  final String id;
  final String name;
  // final String createdAt;

  Attention({
    this.id,
    this.name,
  });

  factory Attention.fromJson(Map<String, dynamic> json) {
    return Attention(
      id: json['id'] ?? '',
      name: json['atensi'] ?? '',
    );
  }
}
