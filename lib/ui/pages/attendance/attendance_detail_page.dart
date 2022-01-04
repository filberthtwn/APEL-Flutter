part of '../pages.dart';

class AttendanceDetailPage extends StatelessWidget {
  final Attendance attendance;

  const AttendanceDetailPage({Key key, this.attendance}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Absensi Detail",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                customTextFieldGroup(
                  context: context,
                  labelText: "Tanggal",
                  isEnabled: false,
                  isSecured: false,
                  isDropdown: false,
                  value: attendance.tanggal,
                ),
                SizedBox(
                  height: 24.0,
                ),
                customTextFieldGroup(
                  context: context,
                  labelText: "Waktu",
                  isEnabled: false,
                  isSecured: false,
                  isDropdown: false,
                  value: _formatUTCtoCurrentTimeZone(
                    time: attendance.createdAt.split("T")[1].substring(0, 5),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                customTextFieldGroup(
                  context: context,
                  labelText: "Tipe Presensi",
                  isEnabled: false,
                  isSecured: false,
                  isDropdown: false,
                  value: attendance.presensi,
                ),
                SizedBox(
                  height: 24.0,
                ),
                customTextFieldGroup(
                  context: context,
                  labelText: "Keterangan",
                  isEnabled: false,
                  isSecured: false,
                  isDropdown: false,
                  value: attendance.keterangan,
                  //linetext: 4
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  "Selfie Gambar Wajah",
                  style: TextStyle(
                    fontFamily: "ProximaNova",
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: AppColor.TEXTFIELD_GROUP_LABEL_COLOR,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                buildCircleImage(
                  width: 200,
                  height: 200,
                  imagePath: attendance.foto,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
