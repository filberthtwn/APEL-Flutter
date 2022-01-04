part of '../../pages.dart';

// ignore: must_be_immutable
class DocTraceDetailPage extends StatefulWidget {
  String _documentId;

  DocTraceDetailPage({@required documentId}) {
    _documentId = documentId;
  }

  @override
  _DocTraceDetailState createState() => _DocTraceDetailState();
}

class _DocTraceDetailState extends State<DocTraceDetailPage> {
  bool _isDataLoaded = false;

  @override
  initState() {
    // EasyLoading.show();
    setupData();
    super.initState();
  }

  void setupData() {
    DocTraceViewModel.shared.getDocumentDetail(id: widget._documentId);
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse _apiResponse = Provider.of<DocTraceViewModel>(context).apiResponse;
    Document _newDocument = Provider.of<DocTraceViewModel>(context).document;
    bool _isSuccess = Provider.of<DocTraceViewModel>(context).isSuccess;
    String _errMsg = Provider.of<DocTraceViewModel>(context).errorMsg;

    if (_errMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
      Provider.of<DocTraceViewModel>(context, listen: false).resetErrMsg();
    }

    if (_newDocument != null) {
      this._isDataLoaded = true;
    }

    if (_isSuccess) {
      EasyLoading.dismiss();
      Provider.of<DocTraceViewModel>(context, listen: false).resetIsSuccess();
    }

    if (_apiResponse != null) {
      LoadingWidget.shared.showSuccess(_apiResponse.message);
      Provider.of<DocTraceViewModel>(context, listen: false).reset();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: 'Detail Berkas',
        showSearchBar: false,
        actions: [
          QrCodeIconButtonWidget(
            jsonData: _generateDocQrCode(widget._documentId),
          ),
        ],
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              if (!_isDataLoaded)
                DocTraceDetailShimmer()
              else
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                width: double.infinity,
                                child: Wrap(
                                  spacing: 8,
                                  direction: Axis.vertical,
                                  children: [
                                    _buildTextAlignLeft(
                                      text: _newDocument.status,
                                      color: AppColor.PRIMARY_COLOR,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      maxLines: 2,
                                    ),
                                    _buildTextAlignLeft(
                                      text: _newDocument.docNumber,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 2,
                                    ),
                                    _buildTextAlignLeft(
                                      text: DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd HH:mm:ss', newDateFormat: "dd MMMM yyyy", dateString: _newDocument.date),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: AppColor.LINE_COLOR,
                                height: 1,
                                thickness: 2,
                              ),
                              SizedBox(height: 24),
                              Container(
                                // decoration: BoxDecoration(color: Colors.red),
                                width: double.infinity,
                                child: Wrap(
                                  spacing: 8,
                                  direction: Axis.vertical,
                                  children: [
                                    _buildTextAlignLeft(text: 'No. Laporan', fontWeight: FontWeight.w600, color: AppColor.TEXTFIELD_GROUP_LABEL_COLOR),
                                    _buildTextAlignLeft(
                                      text: _newDocument.reportNumber,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32),
                              Container(
                                height: 50,
                                width: double.infinity,
                                // decoration: BoxDecoration(color: Colors.green),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildTextAlignLeft(text: 'Butuh Tindakan', fontWeight: FontWeight.w600, color: AppColor.TEXTFIELD_GROUP_LABEL_COLOR),
                                          SizedBox(height: 8),
                                          _buildTextAlignLeft(
                                            text: _newDocument.neededAction ?? '',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildTextAlignLeft(text: 'Tanda Tangan', fontWeight: FontWeight.w600, color: AppColor.TEXTFIELD_GROUP_LABEL_COLOR),
                                          SizedBox(height: 8),
                                          _buildTextAlignLeft(
                                            text: _newDocument.signaturedBy,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        Expanded(
                          child: Container(
                            // decoration: BoxDecoration(color: Colors.blue),
                            width: double.infinity,
                            // height: 50,
                            child: DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  Container(
                                    // decoration: BoxDecoration(color: Colors.red),
                                    child: TabBar(
                                      indicatorColor: AppColor.PRIMARY_COLOR,
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                      labelColor: AppColor.PRIMARY_COLOR,
                                      tabs: [
                                        Tab(text: "Pelapor"),
                                        Tab(text: "Terlapor"),
                                        Tab(text: "Anggota"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      // decoration: BoxDecoration(color: Colors.green),
                                      height: 100,
                                      child: TabBarView(
                                        children: [
                                          Container(
                                            child: ListView.separated(
                                              separatorBuilder: (context, index) => Divider(
                                                color: AppColor.LINE_COLOR,
                                                height: 1,
                                                thickness: 1,
                                              ),
                                              itemCount: (_isDataLoaded) ? _newDocument.accusers.length : 10,
                                              itemBuilder: (context, index) {
                                                if (!_isDataLoaded) {
                                                  return Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 24),
                                                    child: ShimmerWidget(),
                                                  );
                                                }
                                                final accuser = _newDocument.accusers[index];
                                                return _buildDocTraceDetailReporterItem(accuser: accuser);
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: ListView.separated(
                                              separatorBuilder: (context, index) => Divider(
                                                color: AppColor.LINE_COLOR,
                                                height: 1,
                                                thickness: 1,
                                              ),
                                              itemCount: (_isDataLoaded) ? _newDocument.defendants.length : 10,
                                              itemBuilder: (context, index) {
                                                if (!_isDataLoaded) {
                                                  return Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 24),
                                                    child: ShimmerWidget(),
                                                  );
                                                }
                                                final defendant = _newDocument.defendants[index];
                                                return _buildDocTraceDetailReportedItem(defendant: defendant);
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: ListView.separated(
                                              separatorBuilder: (context, index) => Divider(
                                                color: AppColor.LINE_COLOR,
                                                height: 1,
                                                thickness: 1,
                                              ),
                                              itemCount: (_isDataLoaded) ? _newDocument.members.length : 10,
                                              itemBuilder: (context, index) {
                                                if (!_isDataLoaded) {
                                                  return Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 24),
                                                    child: ShimmerWidget(),
                                                  );
                                                }
                                                final member = _newDocument.members[index];
                                                return _buildDocTraceDetailMemberItem(member: member);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _buildDocTraceDetailFooter(
                                    context: context,
                                    documentId: _newDocument.id,
                                    docHistories: _newDocument.docHistories,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}

class DocTraceDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: double.infinity,
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: AppColor.SHIMMER_BASE_COLOR,
                highlightColor: AppColor.SHIMMER_HIGHLIGHT_COLOR,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 200,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      SizedBox(height: 32),
                      for (var i = 0; i < 10; i++)
                        Container(
                          margin: EdgeInsets.only(bottom: 24),
                          child: Row(
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.85,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          height: 32,
                                          width: constraints.maxWidth * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDocTraceDetailFooter({
  BuildContext context,
  @required String documentId,
  List<DocHistory> docHistories,
}) =>
    customFooterContainerWithShadow(
      child: Row(
        children: [
          Expanded(
            child: CustomButtonWidget(
              title: 'Tracking',
              pressHandler: () => {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => DocTraceTrackingPage(docHistories: docHistories ?? []),
                  ),
                ),
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: CustomButtonWidget(
              title: 'Verifikasi',
              backgroundColor: AppColor.SUCCESS_BTN_COLOR,
              pressHandler: () => {
                EasyLoading.show(),
                Provider.of<DocTraceViewModel>(context, listen: false).verifyDocument(
                  id: documentId,
                ),
              },
            ),
          ),
        ],
      ),
    );

String _generateDocQrCode(String documentId) {
  final jsonData = {
    'berkas_id': documentId,
  };
  inspect(jsonData);
  return json.encode(jsonData);
}
