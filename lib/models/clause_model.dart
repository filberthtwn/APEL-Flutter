import 'package:flutter/cupertino.dart';

class Clause {
  final String name;
  // final String phoneNumber;

  Clause({
    @required this.name,
    // @required this.phoneNumber,
  });

  factory Clause.fromJson(Map<String, dynamic> json) {
    return Clause(
      name: json['nama_pasal'],
    );
  }
}
