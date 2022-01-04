part of '../pages.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _scrollController = ScrollController();

  //* Variables for pagination
  int _currentPage = 1;
  int _totalPage = 0;

  //* Variables for loading
  bool _isLoaded = false;

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionStatus;
  LocationData locationData;
  bool showDisclosure = false;

  @override
  initState() {
    this._scrollController.addListener(this._scrollConListener);
    super.initState();
  }

  void setupData() {
    Provider.of<AttendanceViewModel>(context, listen: false)
        .getAllAttendance(page: this._currentPage);
  }

  void _scrollConListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        this._currentPage < _totalPage) {
      _currentPage++;
      this.setupData();
    }
  }

  void _getCurrentLocation() async {
    this._serviceEnabled = await this.location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await this.location.requestService();
      if (!_serviceEnabled) {
        Navigator.pop(context);
        return;
      }
      // else {
      //   setState(() {});
      // }
    }
    setState(() {});
    this._permissionStatus = await this.location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      this.showDisclosure = true;
      return;
      // _permissionStatus = await this.location.requestPermission();
    }
    if (_permissionStatus == PermissionStatus.granted) {
      this.showDisclosure = false;
      this.locationData = await this.location.getLocation();
      setState(() {});
    }
  }

  @override
  deactivate() {
    Provider.of<AttendanceViewModel>(context, listen: false).reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //* Bind model data from ViewModel
    final _attendancesProvider =
        Provider.of<AttendanceViewModel>(context).attendances;
    if (_attendancesProvider != null) {
      this._isLoaded = true;
    } else {
      this._currentPage = 1;
      this._isLoaded = false;
      this.setupData();
    }
    //* Bind totalPage from ViewModel for pagination
    this._totalPage = Provider.of<AttendanceViewModel>(context).totalPage;

    //* Bind errMsg data from ViewModel
    String _errMsg = Provider.of<AttendanceViewModel>(context).errorMsg;

    if (_errMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
    }
    if (showDisclosure) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SvgPicture.asset('assets/images/ic_location_pin.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Gunakan lokasi anda",
                    style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Text(
                  "APEL membutuhkan data lokasi anda untuk mendeteksi koordinat hanya saat anda membuka aplikasi dan menggunakan fitur submit absensi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "ProximaNova",
                    fontSize: 17,
                  ),
                ),
                Spacer(),
                Image.asset("assets/images/maps-image.png"),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 55),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tolak",
                              style: TextStyle(
                                fontFamily: "ProximaNova",
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColor.PRIMARY_COLOR,
                              ))),
                      Spacer(),
                      TextButton(
                          onPressed: () async {
                            await location.requestPermission();
                            showDisclosure = false;
                            this.locationData =
                                await this.location.getLocation();
                            setState(() {});
                          },
                          child: Text("Izinkan",
                              style: TextStyle(
                                fontFamily: "ProximaNova",
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColor.PRIMARY_COLOR,
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: "Absensi",
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                _getCurrentLocation();
                if (locationData != null) {
                  Navigator.of(context).pushNamed("/attendance/create",
                      arguments: this.locationData);
                }
              }),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          controller: this._scrollController,
          padding: EdgeInsets.only(top: 16),
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
            height: 1,
            indent: 24,
          ),
          itemCount: (this._isLoaded)
              ? _attendancesProvider.length +
                  ((this._currentPage < this._totalPage) ? 1 : 0)
              : 10,
          itemBuilder: (context, index) {
            if (!this._isLoaded && this._currentPage == 1) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ShimmerWidget(),
              );
            }
            if (index > (_attendancesProvider.length - 1)) {
              return PaginationLoadingWidget();
            }

            return Container(
              child: _buildAttendanceListTile(
                context: context,
                attendance: _attendancesProvider[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

ClipOval _buildAttendanceImage(
        {@required double height,
        @required double width,
        @required String profilePictureUrl}) =>
    ClipOval(
      child: Image(
        height: height,
        width: width,
        fit: BoxFit.cover,
        image: (profilePictureUrl != null)
            ? NetworkImage(profilePictureUrl)
            : AssetImage('assets/images/img_icon.jpg'),
      ),
    );

Widget _buildAttendanceListTile(
        {BuildContext context, @required Attendance attendance}) =>
    ListTile(
      contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
      leading: _buildAttendanceImage(
          height: 55, width: 55, profilePictureUrl: attendance.foto),
      title: _buildTextAlignLeft(
        text: attendance.tanggal,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      subtitle: _buildTextAlignLeft(
        text: attendance.keterangan,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColor.TEXT_LIGHT_MUTED_COLOR,
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Text(
          //* Time formater
          _formatUTCtoCurrentTimeZone(
            time: attendance.createdAt.split("T")[1].substring(0, 5),
          ),
          // attendance.createdAt.split("T")[1].substring(0, 2),
          // DateTime.now().timeZoneOffset.isNegative.toString(),
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed("/attendance/detail", arguments: attendance);
      },
    );

//* time format => HH:MM
String _formatUTCtoCurrentTimeZone({String time}) {
  int hour = int.parse(time.split(":")[0]);
  String minute = time.split(":")[1];
  if (!DateTime.now().timeZoneOffset.isNegative) {
    hour += DateTime.now().timeZoneOffset.inHours;
  } else {
    hour -= DateTime.now().timeZoneOffset.inHours;
  }
  if (hour >= 24) hour -= 12;
  time = hour.toString() + ":" + minute;
  return time;
}
