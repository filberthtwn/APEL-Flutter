part of 'pages.dart';

// ignore: must_be_immutable
class TimelinePage extends StatefulWidget {
  BuildContext context;
  HomeInterface homeInterface;

  TimelinePage({this.context, this.homeInterface});

  @override
  _TimelinePageState createState() => _TimelinePageState(context);
}

class _TimelinePageState extends State<TimelinePage> {
  ScrollController _scrollController;

  BuildContext context;
  _TimelinePageState(this.context);

  bool _isLoaded = false;

  @override
  initState() {
    this.setupData();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void setupData() {
    Provider.of<BannerViewModel>(context, listen: false).getAllBanner();
    Provider.of<PoliceReportViewModel>(context, listen: false).getAllSummaryLocationReport();
  }

  @override
  Widget build(context) {
    Set<Marker> markers = {};

    //* Bind model data from ViewModel
    final _banners = Provider.of<BannerViewModel>(context).banners;
    final _summaryLocationReports = Provider.of<PoliceReportViewModel>(context).summaryLocationReports;

    for (var i = 0; i < _summaryLocationReports.length; i++) {
      markers.add(_buildMarker(_summaryLocationReports[i]));
    }
    if (_banners != null) {
      this._isLoaded = true;
    }

    //* Bind errMsg data from ViewModel
    String _errMsg = Provider.of<BannerViewModel>(context).errorMsg;

    //* Show error message
    if (_errMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
    }

    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              top: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: CustomPaint(
                  painter: CurvePainter(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  // Running Banner
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 150.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    itemCount: (this._isLoaded) ? _banners.length : 3,
                    itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                      if (!this._isLoaded) {
                        return ShimmerBannerWidget(index: index);
                      }
                      return Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppColor.LINE_DARK_COLOR,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(_banners[index].imageUrl),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 48),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MenuItemWidget(
                              iconPath: 'assets/images/ic_police_report.svg',
                              title: 'Laporan Polisi',
                              onTap: () => Navigator.of(context).pushNamed("/police_report"),
                            ),
                            MenuItemWidget(
                              iconPath: 'assets/images/ic_member.svg',
                              title: 'Anggota',
                              onTap: () => Navigator.of(context).pushNamed("/police-member"),
                            ),
                            MenuItemWidget(
                              iconPath: 'assets/images/ic_prisoner.svg',
                              title: 'Tahanan',
                              onTap: () => Navigator.of(context).pushNamed("/prisoner"),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // cross: MainAxisAlignment.center,
                          children: [
                            MenuItemWidget(
                              iconPath: 'assets/images/ic_doc_trace.svg',
                              title: 'Trace Berkas',
                              onTap: () => Navigator.of(context).pushNamed("/doc_trace"),
                            ),
                            MenuItemWidget(
                              iconPath: 'assets/images/ic_attendance.svg',
                              title: 'Absensi',
                              onTap: () => Navigator.of(context).pushNamed("/attendance"),
                            ),
                            MenuItemWidget(
                              iconPath: 'assets/images/ic_calendar.svg',
                              title: 'Kalender',
                              onTap: () => Navigator.of(context).pushNamed("/calendar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                "Peta Crime",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () => Navigator.of(context).pushNamed("/peta-crime"),
                                child: Text(
                                  "More",
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 366,
                          height: 185,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            child: new GoogleMap(
                              // onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(-6.1753871, 106.8249641),
                                zoom: 15,
                              ),
                              markers: markers,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 55) {
      widget.homeInterface.changeNavbarColor(Colors.white);
      return;
    }
    widget.homeInterface.changeNavbarColor(AppColor.PRIMARY_COLOR);
  }

  Marker _buildMarker(SummaryLocationReport summaryLocationReport) {
    return new Marker(
        markerId: MarkerId(summaryLocationReport.laporanId),
        position: new LatLng(double.parse(summaryLocationReport.latitude), double.parse(summaryLocationReport.longitude)),
        onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => PoliceReportDetail(policeReportId: summaryLocationReport.laporanId)),
            ),
        infoWindow: InfoWindow(
          title: summaryLocationReport.namaSubWilayah,
          snippet: summaryLocationReport.nomorLaporan,
        )
        // width: 50.0,
        // height: 50.0,
        // builder: (ctx) => new Container(
        //     child: new Icon(
        //   Icons.location_on,
        //   color: Colors.red,
        // )),
        );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColor.PRIMARY_COLOR;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MenuItemWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  MenuItemWidget({@required this.onTap, @required this.iconPath, @required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Column(
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.PRIMARY_BTN_COLOR,
            ),
            child: Center(child: SvgPicture.asset(this.iconPath)),
          ),
          SizedBox(height: 8),
          Text(
            this.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
