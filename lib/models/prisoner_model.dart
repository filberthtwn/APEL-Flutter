import 'package:flutter/cupertino.dart';

class Prisoner {
  final String id;
  final String fullName;
  final String gender;
  final String arrestedStartDate;
  final String arrestedEndDate;
  final String arrestedStatus;
  final String profilePictureUrl;
  final String reportNumber;

  Prisoner({
    @required this.id,
    this.fullName,
    this.gender,
    this.arrestedStartDate,
    this.arrestedEndDate,
    this.arrestedStatus,
    this.profilePictureUrl,
    this.reportNumber,
  });

  factory Prisoner.fromJson(Map<String, dynamic> json) {
    return Prisoner(
      id: json['tahanan_id'] ?? '-',
      fullName: json['nama_lengkap'] ?? '-',
      gender: json['jenis_kelamin'] ?? '-',
      arrestedStartDate: json['mulai_ditahan'] ?? '-',
      arrestedEndDate: json['masa_habis_tahanan'] ?? '-',
      arrestedStatus: json['status_penahanan'] ?? '-',
      profilePictureUrl: json['foto'],
      reportNumber: json['nomor_laporan'] ?? '-',
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'user_id': id,
  //     // 'name': name,
  //     // 'email': email,
  //     // 'balance': balance,
  //   };
  // }
}
