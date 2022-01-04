part of '../pages.dart';

class ScanQRPage extends StatefulWidget {
  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  IconData _flashIcon = Icons.flash_on;
  bool _isFlashEnabled = false;

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Scan Laporan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                    icon: Icon(this._flashIcon),
                    color: Colors.white,
                    onPressed: () async {
                      this._isFlashEnabled = !this._isFlashEnabled;
                      if (this._isFlashEnabled) {
                        this._flashIcon = Icons.flash_off;
                      } else {
                        this._flashIcon = Icons.flash_on;
                      }
                      await controller.toggleFlash();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    this.controller.scannedDataStream.listen((result) {
      this.controller.pauseCamera();

      Map<String, dynamic> jsonData = json.decode(result.code);
      if (jsonData['laporan_id'] != null) {
        final policeReport = PoliceReport.fromJson(jsonData);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => PoliceReportDetail(policeReportId: policeReport.id)),
        );
      } else {
        final docs = Document.fromJson(jsonData);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => DocTraceDetailPage(documentId: docs.id)),
        );
      }
    });
  }
}
