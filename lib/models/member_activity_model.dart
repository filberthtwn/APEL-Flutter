class MemberActivity {
  final String id;
  final String title;
  final String investigatorName;
  final String date;
  final String dutyType;
  final String reportCode;
  final String concern;
  final String description;
  final String profilePicture;
  final String phoneNumber;

  MemberActivity({
    this.id,
    this.title,
    this.investigatorName,
    this.date,
    this.dutyType,
    this.reportCode,
    this.concern,
    this.description,
    this.profilePicture,
    this.phoneNumber,
  });

  factory MemberActivity.fromJson(Map<String, dynamic> json) {
    return MemberActivity(
      id: json['agenda_id'] ?? '',
      title: json['judul_agenda'] ?? '',
      investigatorName: json['nama_penyidik'] ?? '',
      date: json['dari_tanggal'] ?? '',
      dutyType: json['tipe_piket'] ?? '',
      reportCode: json['nomor_laporan'] ?? '',
      concern: json['perihal'] ?? '',
      description: json['keterangan'] ?? '',
      profilePicture: json['foto'] ?? '',
      phoneNumber: json['no_telepon'] ?? '',
    );
  }
}
