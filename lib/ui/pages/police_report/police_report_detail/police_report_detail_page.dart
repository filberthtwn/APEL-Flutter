part of '../../pages.dart';

// ignore: must_be_immutable
class PoliceReportDetail extends StatefulWidget {
  // PoliceReport _policeReport;
  String _policeReportId;

  PoliceReportDetail({policeReportId}) {
    // this._policeReport = policeReport;
    this._policeReportId = policeReportId;
  }

  @override
  _PoliceReportDetailState createState() => _PoliceReportDetailState();
}

class _PoliceReportDetailState extends State<PoliceReportDetail> {
  // final policeReportVM = PoliceReportViewModel();
  bool _isDataLoaded = false;

  @override
  initState() {
    // EasyLoading.show();
    setupData();
    super.initState();
  }

  void setupData() {
    PoliceReportViewModel.shared.getPoliceReportDetail(id: widget._policeReportId);
  }

  @override
  Widget build(BuildContext context) {
    String filePath = Provider.of<PoliceReportViewModel>(context).filePath;
    PoliceReport _newPoliceReport = Provider.of<PoliceReportViewModel>(context).policeReport;

    this._isDataLoaded = (_newPoliceReport != null);

    if (filePath != null) {
      EasyLoading.dismiss();
      OpenFile.open(filePath);
      Provider.of<PoliceReportViewModel>(context, listen: false).resetFilePath();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Detail Laporan',
          showSearchBar: false,
          actions: [
            DownloadPoliceReportWidget(
              policeReportId: widget._policeReportId,
            ),
            QrCodeIconButtonWidget(jsonData: _generateQrCode(widget._policeReportId)),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              if (!_isDataLoaded)
                PoliceReportDetailShimmer()
              else
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    child: _buildTextAlignLeft(
                                      text: _newPoliceReport.reportNumber,
                                      maxLines: 2,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Visibility(
                                  visible: _newPoliceReport.isAttention,
                                  child: Row(
                                    children: [
                                      _buildTextAlignLeft(
                                        text: 'Atensi (${_newPoliceReport.attention})',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  _buildReportLocText(
                                    subRegion: _newPoliceReport.subLocation,
                                    region: _newPoliceReport.location,
                                  ),
                                  SizedBox(width: 8),
                                  _buildReportDateText(_newPoliceReport.date),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _buildTextAlignLeft(text: 'Pelapor:', fontSize: 14, fontWeight: FontWeight.bold),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: _buildTextAlignLeft(
                                            text: _newPoliceReport.accuserName,
                                            maxLines: 1,
                                            fontSize: 14,
                                          ),
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
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                Container(
                                  child: TabBar(
                                    indicatorColor: AppColor.PRIMARY_COLOR,
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                    labelColor: AppColor.PRIMARY_COLOR,
                                    tabs: [
                                      Tab(text: "Informasi"),
                                      Tab(text: "Penyidik"),
                                      Tab(text: "Tahanan"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    // decoration: BoxDecoration(color: Colors.blue),
                                    child: TabBarView(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
                                          child: DefendantListWidget(
                                            policeReport: _newPoliceReport,
                                            isDataLoaded: this._isDataLoaded,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 24),
                                          child: PoliceReportDetailMemberList(
                                            policeReport: _newPoliceReport,
                                            isDataLoaded: this._isDataLoaded,
                                          ),
                                        ),
                                        Container(
                                          child: PoliceReportDetailPrisonerList(
                                            policeReport: _newPoliceReport,
                                            isDataLoaded: this._isDataLoaded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // _buildDocTraceDetailFooter(context),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PoliceReportDetailShimmer extends StatelessWidget {
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

// ignore: must_be_immutable
class DefendantListWidget extends StatelessWidget {
  PoliceReport _policeReport;
  bool _isDataLoaded = false;

  DefendantListWidget({@required policeReport, @required isDataLoaded}) {
    this._policeReport = policeReport;
    this._isDataLoaded = isDataLoaded;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: AppColor.LINE_COLOR,
        height: 1,
        thickness: 1,
      ),
      itemCount: 6,
      // ignore: missing_return
      itemBuilder: (context, index) {
        if (!this._isDataLoaded) return ShimmerWidget();
        switch (index) {
          case 0:
            return Container(
              padding: EdgeInsets.only(top: 24),
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: AppColor.LINE_COLOR,
                  height: 1,
                  thickness: 1,
                ),
                itemCount: ((_policeReport.defendants.length > 0) ? _policeReport.defendants.length : 1) + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return PoliceReportInfoHeader(title: 'Terlapor');
                  }
                  return Container(
                    padding: EdgeInsets.all(16),
                    // child:
                    child: _buildTextAlignLeft(
                      text: (_policeReport.defendants.length > 0) ? _policeReport.defendants[index - 1].fullName : 'Tiidak ada terlapor',
                    ),
                  );
                },
              ),
            );
            break;
          case 1:
            return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: AppColor.LINE_COLOR,
                height: 1,
                thickness: 1,
              ),
              itemCount: 1 + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PoliceReportInfoHeader(title: 'Kronologi');
                }
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '${ParserHelper.shared.parseHtmlString(this._policeReport.chronology) ?? 'Tidak ada kronologi'}',
                    style: TextStyle(fontSize: 17),
                  ),
                );
              },
            );
            break;
          case 2:
            return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                if (index > 0) {
                  return Divider(
                    color: AppColor.LINE_COLOR,
                    height: 1,
                    thickness: 1,
                  );
                }
                return Container();
              },
              itemCount: ((_policeReport.clauses.length > 0) ? _policeReport.clauses.length : 1) + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PoliceReportInfoHeader(title: 'Pasal');
                }
                return Container(
                  padding: EdgeInsets.all(16),
                  child: _buildTextAlignLeft(
                    text: _policeReport.clauses[index - 1].name,
                    maxLines: 3,
                  ),
                );
              },
            );
            break;
          case 3:
            return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: AppColor.LINE_COLOR,
                height: 1,
                thickness: 1,
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PoliceReportInfoHeader(title: 'Status', leadingTitle: _policeReport.status);
                }
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: double.infinity,
                            height: 30,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    width: double.infinity,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColor.PRIMARY_LIGHT_COLOR,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    width: constraints.maxWidth * (_policeReport.statusPercentage.toDouble() / 100),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColor.ORANGE_COLOR,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      Text('${_policeReport.statusPercentage}%', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                    ],
                  ),
                );
              },
            );
            break;
          case 4:
            return Container(
              margin: EdgeInsets.only(top: 32),
              width: double.infinity,
              child: Column(children: [
                CustomButtonWidget(
                  title: 'Progress Perkara',
                  pressHandler: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => DocTraceTrackingPage(reportHistories: this._policeReport.reportHistories)),
                    );
                  },
                ),
                SizedBox(height: 16),
                CustomButtonWithImageWidget(
                  title: 'Salin Laporan',
                  textColor: AppColor.PRIMARY_COLOR,
                  backgroundColor: AppColor.WHATSAPP_COLOR,
                  border: BorderSide(
                    color: AppColor.PRIMARY_COLOR,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  pressHandler: () async {
                    copyToClipboard(_policeReport);
                  },
                ),
              ]),
            );
          case 5:
            return Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd HH:mm:ss', newDateFormat: 'dd MMMM yyyy HH:mm', dateString: this._policeReport.createdAt),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 4),
                  Text(
                    this._policeReport.createdBy,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Terakhir diubah: ${DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd HH:mm:ss', newDateFormat: 'dd MMMM yyyy', dateString: this._policeReport.modifiedAt)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            );
          default:
            break;
        }
      },
    );
  }
}

void copyToClipboard(PoliceReport policeReport) async {
  inspect(policeReport);

  List<String> accusers = [];
  for (var accueser in policeReport.accuesers) {
    accusers.add(accueser.fullName);
  }

  List<String> defendants = [];
  for (var defendant in policeReport.defendants) {
    accusers.add(defendant.fullName);
  }

  List<String> clauses = [];
  for (var clause in policeReport.clauses) {
    clauses.add(clause.name);
  }

  String repostHistories = '';
  for (var i = 65; i < (65 + policeReport.reportHistories.length); i++) {
    String reportHistory = '${String.fromCharCode(i)}'
        '. '
        '${policeReport.reportHistories[i - 65].status}: '
        '\n'
        '${ParserHelper.shared.parseHtmlString(policeReport.reportHistories[i - 65].description)}'
        '\n\n';
    repostHistories += reportHistory;
  }

  User _user = SharedPrefHelper.shared.user;
  String message = 'KEPADA : <NAMA PENERIMA>'
      '\n\n'
      'DARI : KANIT ${_user.fullName}'
      '\n\n'
      'PERIHAL : LAPORAN PERKEMBANGAN PENANGANAN KASUS'
      '\n\n'
      '${DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd', newDateFormat: 'dd MMMM yyyy', dateString: policeReport.date)}'
      '\n\n'
      'a. Laporan Polisi Nomor: ${policeReport.reportNumber}'
      '\n'
      'b. Pelapor: ${accusers.join(",")}'
      '\n'
      'c. Terlapor: ${defendants.join(",")}'
      '\n\n'
      'II.PERKARA'
      '\n\n'
      'A. Kronologis'
      '\n'
      '${ParserHelper.shared.parseHtmlString(policeReport.chronology)}'
      '\n\n'
      'B. Object'
      '\n'
      '${policeReport.caseObject ?? "Kosong"}'
      '\n\n'
      'C. Modus Operandi'
      '\n'
      '${policeReport.modusOperandi ?? "Kosong"}'
      '\n\n'
      'III.LANGKAH PENYIDIKAN'
      '\n'
      '$repostHistories'
      'IV.FAKTA PENYIDIKAN'
      '\n'
      '<FAKTA PENYIDIKAN>'
      '\n'
      'V.KESIMPULAN'
      '\n\n'
      '<KESIMPULAN>'
      '\n\n'
      'Demikian yg dapat kami laporkan, terima kasih.'
      '\n\n'
      'DUM.'
      '\n\n'
      'Tembusan :'
      '\n'
      'Wadirreskrimum Polda Metro Jaya';

  Clipboard.setData(ClipboardData(text: message));
  LoadingWidget.shared.showSuccess('Laporan berhasil disalin');
}

class PoliceReportInfoHeader extends StatelessWidget {
  final title;
  final leadingTitle;

  PoliceReportInfoHeader({@required this.title, this.leadingTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.PRIMARY_LIGHT_COLOR,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildTextAlignLeft(text: title, color: AppColor.PRIMARY_COLOR, fontWeight: FontWeight.w600), _buildTextAlignLeft(text: leadingTitle ?? '', color: AppColor.PRIMARY_COLOR, fontWeight: FontWeight.w600)],
      ),
    );
  }
}

// ignore: must_be_immutable
class PoliceReportDetailMemberList extends StatelessWidget {
  PoliceReport _policeReport;
  bool isDataLoaded = false;

  PoliceReportDetailMemberList({@required policeReport, @required isDataLoaded}) {
    this._policeReport = policeReport;
    this.isDataLoaded = isDataLoaded;
  }

  @override
  Widget build(BuildContext context) {
    final members = this._policeReport.members;

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: AppColor.LINE_COLOR,
        height: 1,
        thickness: 1,
      ),
      itemCount: (members.length > 0) ? members.length : 1,
      itemBuilder: (context, index) {
        if (members.length == 0) {
          return Text(
            'Tidak ada data penyidik',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          );
        }
        return PoliceMemberListTile(
          member: this._policeReport.members[index],
          actions: [
            Container(
              height: 32,
              width: 50,
              child: BuildMemberActionButton(
                title: "Chat",
                backgroundColor: Colors.orange,
                onPressed: () async {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => MessagingPage(occupant: this._policeReport.members[index]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 32,
              width: 50,
              child: BuildMemberActionButton(
                title: "Lihat",
                backgroundColor: AppColor.PRIMARY_BTN_COLOR,
                onPressed: () {
                  final member = this._policeReport.members[index];
                  // _buildDetailModal(context, member, _memberProfilesProvider[index], _memberAnalyticsProvider[index]);
                  _buildDetailModal(
                    context: context,
                    member: member,
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class PoliceReportDetailPrisonerList extends StatelessWidget {
  PoliceReport _policeReport;
  // ignore: unused_field
  bool _isDataLoaded = false;

  PoliceReportDetailPrisonerList({@required policeReport, @required isDataLoaded}) {
    this._policeReport = policeReport;
    this._isDataLoaded = isDataLoaded;
  }

  @override
  Widget build(BuildContext context) {
    final prisoners = this._policeReport.prisoners;

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: AppColor.LINE_COLOR,
        height: 1,
        thickness: 1,
      ),
      itemCount: (prisoners.length > 0) ? prisoners.length : 1,
      itemBuilder: (context, index) {
        if (prisoners.length == 0) {
          return Container(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              'Tidak ada data tahanan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          );
        }

        return _buildPrisonerListTile(
          context: context,
          prisoner: prisoners[index],
        );
      },
    );
  }
}

class DownloadPoliceReportWidget extends StatelessWidget {
  final String policeReportId;

  DownloadPoliceReportWidget({@required this.policeReportId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: Icon(
        Icons.save_alt,
        color: Colors.black,
      ),
      onPressed: () async {
        final url = '${Constants.BASE_URL}/api/mobile/v1/export/laporan_polisi/detail/pdf/$policeReportId';
        await canLaunch(url) ? await launch(url) : LoadingWidget.shared.showError("Download failed, there's a problem with the server. Can't open" + '${Constants.BASE_URL}/api/mobile/v1/export/laporan_polisi/detail/pdf/$policeReportId');
      },
    );
  }
}

String _generateQrCode(String policeReportId) {
  final jsonData = {
    'laporan_id': policeReportId,
  };
  inspect(jsonData);
  return json.encode(jsonData);
}
