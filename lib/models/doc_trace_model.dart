import 'package:flutter/cupertino.dart';
import 'package:subditharda_apel/models/accuser_model.dart';
import 'package:subditharda_apel/models/defendant_model.dart';
import 'package:subditharda_apel/models/doc_history_model.dart';
import 'package:subditharda_apel/models/member_model.dart';

class Document {
  final String id;
  final String docNumber;
  final String subject;
  final String date;
  final String reportNumber;
  final String status;
  final String neededAction;
  final String signaturedBy;
  final List<Defendant> defendants;
  final List<Accuser> accusers;
  final List<Member> members;
  final List<DocHistory> docHistories;

  Document({
    @required this.id,
    @required this.docNumber,
    @required this.subject,
    @required this.date,
    @required this.reportNumber,
    @required this.status,
    @required this.neededAction,
    @required this.signaturedBy,
    @required this.defendants,
    @required this.accusers,
    @required this.members,
    @required this.docHistories,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['berkas_id'] ?? '-',
      docNumber: json['nomor_berkas'] ?? '-',
      subject: json['perihal'] ?? '-',
      date: json['tanggal_berkas'] ?? '-',
      reportNumber: json['nomor_laporan'] ?? '-',
      status: json['status_berkas'] ?? '-',
      neededAction: json['butuh_tindakan'] ?? '-',
      signaturedBy: json['tanda_tangan'] ?? '-',
      defendants: List<Defendant>.from(((json['list_terlapor'] as List) ?? []).map((e) => Defendant.fromJson(e))),
      accusers: List<Accuser>.from(((json['list_pelapor'] as List) ?? []).map((e) => Accuser.fromJson(e))),
      members: List<Member>.from(((json['list_anggota'] as List) ?? []).map((e) => Member.fromJson(e))),
      docHistories: List<DocHistory>.from(((json['log_activity'] as List) ?? []).map((e) => DocHistory.fromJson(e))),
    );
  }
}
