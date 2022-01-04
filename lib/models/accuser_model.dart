import 'package:flutter/cupertino.dart';

class Accuser {
  final String reportId;
  final String fullName;
  final String phoneNumber;

  Accuser({
    @required this.reportId,
    @required this.fullName,
    @required this.phoneNumber,
  });

  factory Accuser.fromJson(Map<String, dynamic> json) {
    return Accuser(
      reportId: json['laporan_id'],
      fullName: json['nama_lengkap'],
      phoneNumber: json['nomor_telepon'],
    );
  }
}
