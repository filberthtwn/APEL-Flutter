import 'package:flutter/cupertino.dart';

class Banner {
  final String title;
  final String description;
  final String imageUrl;

  Banner({
    @required this.title,
    @required this.description,
    @required this.imageUrl,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      title: json['judul'],
      description: json['deskripsi'],
      imageUrl: json['image'],
    );
  }
}
