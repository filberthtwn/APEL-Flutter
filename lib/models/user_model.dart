import 'package:flutter/cupertino.dart';

class User {
  final String id;
  final String fullName;
  final String nrpNumber;
  final String unitName;
  final String phoneNumber;
  final String email;
  final String gender;
  final String birthdate;
  final String profilePictureUrl;

  User({
    @required this.id,
    this.fullName = '',
    this.nrpNumber = '',
    this.unitName = '',
    this.phoneNumber = '',
    this.email = '',
    this.gender = '',
    this.birthdate = '',
    this.profilePictureUrl = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['anggota_id'],
      fullName: json['nama_lengkap'],
      nrpNumber: json['nrp'],
      unitName: json['unit'],
      phoneNumber: json['nomor_telepon'],
      email: json['email'],
      gender: json['jenis_kelamin'],
      birthdate: json['tanggal_lahir'],
      profilePictureUrl: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anggota_id': this.id,
      'nama_lengkap': this.fullName,
      'nrp': this.nrpNumber,
      'unit': this.unitName,
      'nomor_telepon': this.phoneNumber,
      'email': this.email,
      'jenis_kelamin': this.gender,
      'tanggal_lahir': this.birthdate,
      'foto': this.profilePictureUrl,
    };
  }
}
