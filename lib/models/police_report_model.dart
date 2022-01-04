import 'package:flutter/cupertino.dart';
import 'package:subditharda_apel/models/defendant_model.dart';
import 'package:subditharda_apel/models/member_model.dart';
import 'package:subditharda_apel/models/prisoner_model.dart';
import 'package:subditharda_apel/models/report_history_model.dart';

import 'accuser_model.dart';
import 'clause_model.dart';

class PoliceReport {
  final String id;
  final String reportNumber;
  final String date;
  final String location;
  final String subLocation;
  final String accuserName;
  final String defendantName;
  final String investigatorName;
  final String status;
  final bool isAttention;
  final String attention;
  final String unit;
  final String chronology;
  final int statusPercentage;
  final String modusOperandi;
  final String caseObject;
  final List<Accuser> accuesers;
  final List<Defendant> defendants;
  final List<Clause> clauses;
  final List<Prisoner> prisoners;
  final List<Member> members;
  final List<ReportHistory> reportHistories;
  final String createdAt;
  final String createdBy;
  final String modifiedAt;

  PoliceReport({
    @required this.id,
    this.reportNumber,
    this.date,
    this.location,
    this.subLocation,
    this.accuserName,
    this.defendantName,
    this.investigatorName,
    this.status,
    this.isAttention,
    this.attention,
    this.unit,
    this.chronology,
    this.statusPercentage,
    this.modusOperandi,
    this.caseObject,
    this.accuesers,
    this.defendants,
    this.clauses,
    this.prisoners,
    this.members,
    this.reportHistories,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
  });

  factory PoliceReport.fromJson(Map<String, dynamic> json) {
    return PoliceReport(
      id: json['laporan_id'],
      reportNumber: json['nomor_laporan'],
      date: json['tanggal_laporan'],
      location: json['wilayah'],
      subLocation: json['sub_wilayah'],
      accuserName: json['pelapor'] ?? '-',
      defendantName: json['terlapor'] ?? '-',
      investigatorName: json['penyidik'],
      status: json['progress_perkara'],
      isAttention: (json['is_atensi'] == 'Y') ? true : false,
      attention: json['atensi'] ?? '',
      unit: json['unit'],
      chronology: json['kronologi'],
      statusPercentage: json['status_percentage'],
      modusOperandi: json['modus_operandi'],
      caseObject: json['objek_perkara'],
      accuesers: List<Accuser>.from(((json['list_pelapor'] as List) ?? []).map((e) => Accuser.fromJson(e))),
      defendants: List<Defendant>.from(((json['list_terlapor'] as List) ?? []).map((e) => Defendant.fromJson(e))),
      clauses: List<Clause>.from(((json['list_pasal'] as List) ?? []).map((e) => Clause.fromJson(e))),
      prisoners: List<Prisoner>.from(((json['list_tahanan'] as List) ?? []).map((e) => Prisoner.fromJson(e))),
      members: List<Member>.from(((json['list_anggota'] as List) ?? []).map((e) => Member.fromJson(e))),
      reportHistories: List<ReportHistory>.from(((json['list_progress_perkara'] as List) ?? []).map((e) => ReportHistory.fromJson(e))),
      createdAt: (json['created'] != null) ? json['created']['date'] : '-',
      createdBy: (json['created'] != null) ? json['created']['by'] : '-',
      modifiedAt: (json['modified'] != null) ? json['created']['date'] : '-',
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

class SummaryLocationReport {
  final String laporanId;
  final String nomorLaporan;
  final String latitude;
  final String longitude;
  final String locationName;
  final String locationLabel;
  final String namaWilayah;
  final String namaSubWilayah;

  SummaryLocationReport({
    @required this.laporanId,
    this.nomorLaporan,
    this.latitude,
    this.longitude,
    this.locationName,
    this.locationLabel,
    this.namaWilayah,
    this.namaSubWilayah,
  });

  factory SummaryLocationReport.fromJson(Map<String, dynamic> json) {
    return SummaryLocationReport(
      laporanId: json['laporan_id'],
      nomorLaporan: json['nomor_laporan'] ?? "-",
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      locationName: json['location_name'] ?? "-",
      locationLabel: json['location_label'] ?? '-',
      namaWilayah: json['nama_wilayah'] ?? '-',
      namaSubWilayah: json['nama_sub_wilayah'] ?? "-",
    );
  }
}
//* rename attribute identifier
