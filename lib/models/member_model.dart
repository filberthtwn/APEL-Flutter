import 'package:flutter/cupertino.dart';

class Member {
  final String id;
  final String fullName;
  final String nrpNumber;
  final String unit;
  final String phoneNumber;
  final String email;
  final String profilePictureUrl;

  Member({@required this.id, this.fullName = '', this.nrpNumber = '', this.unit = '', this.phoneNumber = '', this.email = '', this.profilePictureUrl = ''});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['anggota_id'] ?? '',
      fullName: json['nama_lengkap'] ?? '',
      nrpNumber: json['nrp'] ?? '',
      unit: json['unit'] ?? '',
      phoneNumber: json['no_telepon'] ?? json['nomor_telepon'],
      email: json['email'] ?? '',
      profilePictureUrl: json['foto'] ?? '',
    );
  }
}

class MemberProfile {
  final String id;
  final String namaLengkap;
  final String nrp;
  final String unit;
  final String nomorTelepon;
  final String email;
  final String tanggalLahir;
  final String jenisKelamin;
  final String foto;
  final String point;
  final bool isEditable;
  final CrimeSummary crimeSummary;

  MemberProfile({this.id, this.namaLengkap, this.nrp, this.unit, this.nomorTelepon, this.email, this.tanggalLahir, this.jenisKelamin, this.foto, this.point, this.isEditable, this.crimeSummary});

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      id: json["anggota_id"] ?? "",
      namaLengkap: json["nama_lengkap"] ?? "",
      nrp: json["nrp"] ?? "",
      unit: json["unit"] ?? "",
      nomorTelepon: json["nomor_telepon"] ?? "",
      email: json["email"] ?? "",
      tanggalLahir: json["tanggal_lahir"] ?? "",
      foto: json["foto"] ?? "",
      point: json["point"].toString() ?? "",
      isEditable: json["is_editable"] ?? false,
      crimeSummary: CrimeSummary.fromJson(json["crime_summary"]) ?? "",
    );
  }
}

class CrimeSummary {
  final String crimeClearence;
  final String crimeTotal;

  CrimeSummary({this.crimeClearence, this.crimeTotal});

  factory CrimeSummary.fromJson(Map<String, dynamic> json) {
    return CrimeSummary(crimeClearence: json['crime_clearance'].toString() ?? '', crimeTotal: json['crime_total'].toString() ?? '');
  }
}

class Analytic {
  final String crimeClearence;
  final String crimeTotal;
  final String month;

  Analytic({this.crimeClearence, this.crimeTotal, this.month});

  factory Analytic.fromJson(Map<String, dynamic> json) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String month = json['month'].toString().split("-")[1];
    String monthName = months[int.parse(month) - 1];
    return Analytic(
      crimeClearence: json['crime_clearance'].toString() ?? '',
      crimeTotal: json['crime_total'].toString() ?? '',
      month: monthName ?? '',
    );
  }
}
