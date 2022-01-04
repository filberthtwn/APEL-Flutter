part of 'pages.dart';

class CrimeMapPage extends StatefulWidget {
  const CrimeMapPage({Key key}) : super(key: key);

  @override
  _CrimeMapPageState createState() => _CrimeMapPageState();
}

class _CrimeMapPageState extends State<CrimeMapPage> {
  Marker _buildMarker(SummaryLocationReport summaryLocationReport) {
    return new Marker(
      markerId: MarkerId(summaryLocationReport.laporanId),
      position: new LatLng(double.parse(summaryLocationReport.latitude),
          double.parse(summaryLocationReport.longitude)),
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (_) => PoliceReportDetail(
                policeReportId: summaryLocationReport.laporanId)),
      ),
      infoWindow: InfoWindow(
        title: summaryLocationReport.namaSubWilayah,
        snippet: summaryLocationReport.nomorLaporan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    final _summaryLocationReports =
        Provider.of<PoliceReportViewModel>(context).summaryLocationReports;

    for (var i = 0; i < _summaryLocationReports.length; i++) {
      markers.add(_buildMarker(_summaryLocationReports[i]));
    }
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: AppColor.PRIMARY_COLOR,
        title: Text("Crime Map"),
      ),
      body: GoogleMap(
        // onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(-6.1753871, 106.8249641),
          zoom: 15,
        ),
        markers: markers,
      ),
    );
  }
}
