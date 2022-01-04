import 'package:flutter/cupertino.dart';

class Attendance {
  final String id;
  final String tanggal;
  final String waktu;
  final String presensi;
  final String foto;
  final String keterangan;
  final String latitude;
  final String longtitude;
  final String createdAt;
  final String namaLengkap;
  final String nrp;

  Attendance({
    @required this.id,
    this.tanggal = '',
    this.waktu = '',
    this.presensi = '',
    this.foto = '',
    this.keterangan = '',
    this.latitude = '',
    this.longtitude = '',
    this.createdAt = '',
    this.namaLengkap = '',
    this.nrp = '',
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    String rawTanggal = json['tanggal_absensi'];
    String tanggal = rawTanggal.split(" ")[0];
    String waktu = rawTanggal.split(" ")[1].substring(0, 5);
    print(tanggal);
    print(waktu);

    return Attendance(
      id: json['absensi_id'] ?? '',
      tanggal: tanggal ?? '',
      waktu: waktu ?? '',
      presensi: json['presensi'] ?? '',
      foto: json['foto'] ?? '',
      keterangan: json['keterangan'] ?? '',
      latitude: json['latitude'] ?? '',
      createdAt: json['created_at'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      nrp: json['nrp'] ?? '',
    );
  }
}
