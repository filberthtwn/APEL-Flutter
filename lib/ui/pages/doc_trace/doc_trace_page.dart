part of '../pages.dart';

class DocTracePage extends StatefulWidget {
  @override
  _DocTraceState createState() => _DocTraceState();
}

class _DocTraceState extends State<DocTracePage> {
  List<Document> _documents;
  bool _isLoading = true;
  String _searchQuery = '';
  final searchCont = FusionsTextEditingController();
  TextEditingController _yearCon;

  @override
  initState() {
    // EasyLoading.show();
    this._yearCon = TextEditingController();
    searchCont.addListener(this._searchContListener);

    setupData();
    super.initState();
  }

  void setupData() {
    DocTraceViewModel.shared.getAllDocTrace(searchQuery: this._searchQuery);
  }

  void _searchContListener() {
    final state = searchCont.didTextFieldEditing(textEditingController: this.searchCont);
    if (state == TextFieldEditingState.BEGIN) {
      return;
    }

    this._isLoading = true;
    this._searchQuery = searchCont.text;
    setState(() {});
    setupData();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _docSummary = Provider.of<DocTraceViewModel>(context).docSummary;
    this._documents = Provider.of<DocTraceViewModel>(context).documents;
    String _errMsg = Provider.of<DocTraceViewModel>(context).errorMsg;

    if (_errMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
    }

    if (this._documents != null) {
      this._isLoading = false;
    }

    if (_docSummary != null) {
      EasyLoading.dismiss();
      copyDocToClipboard(_docSummary);

      Provider.of<DocTraceViewModel>(context, listen: false).docSummary = null;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          title: 'Trace Berkas',
          showSearchBar: true,
          searchBarHint: 'Cari berkas',
          searchCont: searchCont,
          actions: [
            IconButton(
              icon: Icon(
                Icons.content_copy,
                color: Colors.black,
              ),
              onPressed: () => showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                ),
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Container(
                    child: Wrap(
                      runSpacing: 16,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Wrap(
                            runSpacing: 16,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: _buildTextAlignLeft(
                                  text: 'Salin Total Berkas',
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              customTextFieldGroup(
                                context: context,
                                labelText: "Tahun",
                                placeholder: "Masukkan tahun total berkas..",
                                controller: this._yearCon,
                              ),
                              CustomButtonWidget(
                                title: 'Salin',
                                pressHandler: () {
                                  if (this._yearCon.text == '') {
                                    LoadingWidget.shared.showError("Please fill the blanks");
                                    return;
                                  }

                                  EasyLoading.show();
                                  Provider.of<DocTraceViewModel>(context, listen: false).getDocRepotSummary(
                                    year: this._yearCon.text,
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  // return this._policeReportFilterWidget;
                },
              ),
            ),
          ],
        ),
        body: ListView.separated(
          padding: EdgeInsets.only(top: 16),
          separatorBuilder: (context, index) => Divider(
            color: AppColor.LINE_COLOR,
            height: 1,
            indent: 24,
            thickness: 1,
          ),
          itemCount: (!_isLoading) ? _documents.length : 10,
          itemBuilder: (context, index) {
            if (_isLoading) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ShimmerWidget(),
              );
            }
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return DocTraceDetailPage(documentId: _documents[index].id);
                    },
                  ),
                ),
              },
              child: _buildDocTraceItem(document: _documents[index]),
            );
          },
        ),
      ),
    );
  }
}

void copyDocToClipboard(Map<String, dynamic> docSummary) async {
  User _user = SharedPrefHelper.shared.user;
  List<dynamic> letterList = docSummary['daftar_surat'];

  /// Parse start date from ISO Format to "DD-MM-YYYY"
  String startDate = DateFormatter.shared.formatString(oldDateFormat: "yyyy-MM-dd HH:mm:ss", newDateFormat: "dd/MM/yyyy", dateString: docSummary['tanggal_berkas']['tanggal_awal']);

  /// Parse end date from ISO Format to "DD-MM-YYYY"
  String endDate = DateFormatter.shared.formatString(oldDateFormat: "yyyy-MM-dd HH:mm:ss", newDateFormat: "dd/MM/yyyy", dateString: docSummary['tanggal_berkas']['tanggal_terakhir']);

  String message = 'Kepada Yth: <NAMA PENERIMA>'
      '\n\n'
      'Mohon izin melaporkan kpd Direktur, penyelesaian Administrasi Berkas Perkara dan Surat yang masuk, pada Tanggal $startDate s.d. $endDate sbb:'
      '\n\n'
      'I. BERKAS PERKARA: ${docSummary['berkas_perkara']} (${Terbilang(number: docSummary['berkas_perkara']).result()}) dengan Rincian sbb: '
      '\n\n'
      '1. SPDP: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PENGIRIMAN SPDP KEPADA KEJAKSAAN")["total_berkas"]}'
      '\n'
      '2. TAHAP 2: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PENGIRIMAN TERSANGKA DAN BARANG BUKTI TAHAP 2 KEJAKSAAN")["total_berkas"]}'
      '\n'
      '3. TAHAP 1: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PENGIRIMAN BERKAS PERKARA (TAHAP 1)")["total_berkas"]}'
      '\n'
      '4. SP3: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH PENGHENTIAN PENYIDIKAN (SP3)")["total_berkas"]}'
      '\n'
      '5. S.P GELAR WASSIDIK: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH GELAR DIREKTORAT (WASSIDIK)")["total_berkas"]}'
      '\n'
      '6. S.P GELAR SUBDIT: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH GELAR SUBDIT")["total_berkas"]}'
      '\n'
      '7. S.P KAP: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH PENANGKAPAN TERSANGKA (SP.KAP)")["total_berkas"]}'
      '\n'
      '8. S.P HAN: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH PENAHANAN (SP.HAN)")["total_berkas"]}'
      '\n'
      '9. S.P GLEDAH: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH PENGGELEDAHAN (S.P.DAH)")["total_berkas"]}'
      '\n'
      '10. S.P SITA: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH PENYITAAN (SP.SITA)")["total_berkas"]}'
      '\n'
      '11. SPGL TSK: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH MEMANGGIL TERSANGKA (SPGL TSK)")["total_berkas"]}'
      '\n'
      '12. PERPANJANG PENAHANAN: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERPANJANGAN PENAHANAN KEPADA KEJAKSAAN")["total_berkas"]}'
      '\n'
      '13. SURAT DI BUAT PENYIDIK: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERPANJANGAN PENAHANAN KEPADA KEJAKSAAN")["total_berkas"]}'
      '\n'
      '14. SP2LID: ${letterList.firstWhere((e) => e['berkas'] == "SURAT PERINTAH SP2LID ( SURAT PERINTAH PENHENTIAN PENYELIDIKAN)")["total_berkas"]}'
      '\n'
      '15. SPDP LANJUTAN: ${letterList.firstWhere((e) => e['berkas'] == "SURAT SPDP LANJUTAN")["total_berkas"]}'
      '\n\n'
      'Jumlah Produk Surat yang dibuat penyidik: ${docSummary['jumlah_surat']}}'
      '\n\n'
      'II. SURAT MASUK / DISPOSISI: 0 (....) dari:'
      '\n\n'
      'SURAT MASUK INSTANSI POLRI: 0'
      '\n'
      'SURAT MASUK LUAR INSTANSI POLRI: 0'
      '\n'
      'DUMAS: 0'
      '\n'
      'TAGGUH: 0'
      '\n'
      'BIDKUM: 0'
      '\n'
      'CABUT LP: 0'
      '\n\n'
      'III. N.D PERMOHONAN DF: <<Jumlah Permohonan DF>>'
      '\n\n'
      'IV. BERKAS KEMBALI: <<Jumlah Pengajuan Berkas yang kembali>>'
      '\n\n'
      'V. BERKAS PERKARA / SURAT YANG BELUM TTD / PARAF /DISPOSISI: <<Jumlah Pengajuan Berkas yang belum di ttd/Approve>>'
      '\n'
      'Demikian Kami Laporkan. Terima Kasih'
      '\n\n'
      'Wadirreskrimum PMJ.';

  Clipboard.setData(ClipboardData(text: message));
  LoadingWidget.shared.showSuccess('Total Berkas berhasil disalin');
}
