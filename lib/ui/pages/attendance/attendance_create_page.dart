part of '../pages.dart';

class AttendanceCreatePage extends StatefulWidget {
  LocationData locationData;
  AttendanceCreatePage(LocationData locationData) {
    this.locationData = locationData;
  }
  @override
  _AttendanceCreatePageState createState() =>
      _AttendanceCreatePageState(locationData);
}

class _AttendanceCreatePageState extends State<AttendanceCreatePage>
    implements WheelPickerDelegate {
  LocationData locationData;
  _AttendanceCreatePageState(LocationData locationData) {
    this.locationData = locationData;
  }
  final _types = ["Dinas Luar Kantor", "Masuk Kantor"];
  bool showDisclosure = false;

  String _tanggalAbsensi = "";
  String _tipe = "";
  String _keterangan = "";
  File _image;
  final picker = ImagePicker();
  final _tipeCont = FusionsTextEditingController();
  final _keteranganCont = FusionsTextEditingController();

  @override
  initState() {
    this._getCurrentTime();
    this._tipeCont.addListener(this._tipeContListener);
    this._keteranganCont.addListener(this._keteranganContListener);
    super.initState();
  }

  Future takePicture() async {
    this._image = await Navigator.push<File>(
        context, MaterialPageRoute(builder: (_) => CameraPage()));
    setState(() {});
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _tipeContListener() {
    final state = this
        ._tipeCont
        .didTextFieldEditing(textEditingController: this._tipeCont);
    if (state == TextFieldEditingState.BEGIN) {
      return;
    }
    this._tipe = this._tipeCont.text;
    setState(() {});
  }

  void _keteranganContListener() {
    final state = this
        ._keteranganCont
        .didTextFieldEditing(textEditingController: this._keteranganCont);
    if (state == TextFieldEditingState.BEGIN) {
      return;
    }
    this._keterangan = this._keteranganCont.text;
    setState(() {});
  }

  void _getCurrentTime() async {
    var now = new DateTime.now();
    var dateFormatter = new DateFormat('yyyy-MM-dd');
    var timeFormatter = new DateFormat('Hms');
    String formattedDate = dateFormatter.format(now);
    String formattedTime = timeFormatter.format(now);
    this._tanggalAbsensi = formattedDate + " " + formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = Provider.of<AttendanceViewModel>(context).isSuccess;
    // if (_permissionStatus == PermissionStatus.denied) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Input Absensi",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "Tanggal dan waktu akan didapatkan secara realtime saat absensi disubmit",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24.0,
                ),
                customTextFieldGroup(
                  context: context,
                  labelText: "Tipe Presensi",
                  isSecured: false,
                  isDropdown: true,
                  value: "Dinas Luar Kota",
                  controller: _tipeCont,
                  inputView: WheelPickerWidget(
                      contentList: this._types, delegate: this),
                ),
                SizedBox(
                  height: 24.0,
                ),
                customTextFieldGroup(
                  context: context,
                  labelText: "Keterangan",
                  isSecured: false,
                  isDropdown: false,
                  value:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  controller: _keteranganCont,
                ),
                SizedBox(
                  height: 24.0,
                ),
                GestureDetector(
                  // onTap: () => getImage(),
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text("Camera"),
                            onTap: () async {
                              await takePicture();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_album),
                            title: Text("Galery"),
                            onTap: () async {
                              await getImage();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                    // await takePicture();
                  },
                  child: Column(
                    children: [
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
                      (_image != null)
                          ? ClipOval(
                              child: Image(
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                              image: FileImage(_image),
                            ))
                          // buildCircleImage(
                          //     width: 200, height: 200, imageFile: this._image)
                          : buildCircleImage(
                              width: 200, height: 200, imagePath: ""),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Ganti Gambar",
                        style: TextStyle(
                            color: AppColor.PRIMARY_COLOR,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: "ProximaNova"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                CustomButtonWidget(
                  title: "Kirim",
                  pressHandler: () async {
                    EasyLoading.show();
                    await Provider.of<AttendanceViewModel>(context,
                            listen: false)
                        .createAttendance(
                      keterangan: this._keterangan,
                      locationData: this.locationData,
                      tanggalAbsensi: this._tanggalAbsensi,
                      tipePresensi: this._tipe,
                      selfieWajah: this._image,
                    );
                    if (isSuccess) {
                      LoadingWidget.shared
                          .showSuccess('Absensi berhasil dikirim');
                      Navigator.of(context).pop();
                      EasyLoading.dismiss();
                    }
                    if (!isSuccess) {
                      EasyLoading.dismiss();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didSelectItem(
      int index, WheelPickerWidget pickerView, BuildContext context) {
    setState(() {
      this._tipeCont.text = this._types[index];
    });
  }
}
