import 'package:flutter/cupertino.dart';

class Defendant {
  final String fullName;
  // final String phoneNumber;

  Defendant({
    @required this.fullName,
    // @required this.phoneNumber,
  });

  factory Defendant.fromJson(Map<String, dynamic> json) {
    return Defendant(
      fullName: json['nama_lengkap'],
    );
  }
}
