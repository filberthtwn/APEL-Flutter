part of '../pages.dart';

abstract class PoliceReportDelegate {
  void filterPoliceReportData({
    @required CaseProgress caseProgress,
    @required String isAttention,
    @required Unit unit,
    @required Member member,
    @required Region region,
    @required SubRegion subRegion,
  });
}

class PoliceReportPage extends StatefulWidget {
  @override
  _PoliceReportState createState() => _PoliceReportState();
}

class _PoliceReportState extends State<PoliceReportPage> implements PoliceReportDelegate {
  PoliceReportFilterWidget _policeReportFilterWidget;
  ScrollController _scrollController = ScrollController();
  final searchCont = FusionsTextEditingController();

  CaseProgress _selectedCaseProgress;
  String _selectedAttention;
  Unit _selectedUnit;
  Member _selectedMember;
  Region _selectedRegion;
  SubRegion _selectedSubRegion;

  int _currentPage = 1;
  int _totalPage = 0;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  initState() {
    this.searchCont.addListener(this._searchContListener);
    this._scrollController.addListener(this._scrollConListener);

    this._policeReportFilterWidget = PoliceReportFilterWidget(this);

    setupData();
    super.initState();
  }

  @override
  deactivate() {
    Provider.of<PoliceReportViewModel>(context, listen: false).reset();
    Provider.of<MemberViewModel>(context, listen: false).reset();

    super.deactivate();
  }

  void setupData() {
    filterPoliceReportData(
      caseProgress: this._selectedCaseProgress,
      isAttention: this._selectedAttention,
      member: this._selectedMember,
      unit: this._selectedUnit,
      region: this._selectedRegion,
      subRegion: this._selectedSubRegion,
    );
  }

  void _setupFilterData() {
    Provider.of<PoliceReportViewModel>(context).getAllCaseProgress();
  }

  void _scrollConListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && this._currentPage < _totalPage) {
      _currentPage++;

      // this._isLoading = true;
      setState(() {});
      this.setupData();
    }
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
    List<Member> _members = Provider.of<MemberViewModel>(context).members;

    List<PoliceReport> _policeReports = Provider.of<PoliceReportViewModel>(context).policeReports;
    List<CaseProgress> _caseProgress = Provider.of<PoliceReportViewModel>(context).caseProgress;
    List<Unit> _units = Provider.of<PoliceReportViewModel>(context).units;
    List<Region> _regions = Provider.of<PoliceReportViewModel>(context).regions;
    List<SubRegion> _subRegions = Provider.of<PoliceReportViewModel>(context).subRegions;

    if (_caseProgress != null && _members == null) {
      Provider.of<MemberViewModel>(context).getAllMemberWithoutPagination();
    }

    if (_members != null && _units == null) {
      Provider.of<PoliceReportViewModel>(context, listen: false).getAllUnit();
    }

    if (_units != null && _regions == null) {
      Provider.of<PoliceReportViewModel>(context, listen: false).getAllRegion();
    }

    if (_regions != null && _subRegions == null) {
      Provider.of<PoliceReportViewModel>(context, listen: false).getAllSubRegion(regionCode: 'JKT');
    }

    if (_policeReports != null && _members != null) {
      this._isLoading = false;
    }

    this._totalPage = Provider.of<PoliceReportViewModel>(context).totalPage;

    //* Error message handler for PoliceReportViewModel
    String _errMsg = Provider.of<PoliceReportViewModel>(context).errorMsg;
    if (_errMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
    }

    //* Error message handler for PoliceReportViewModel
    String _memberErrMsg = Provider.of<PoliceReportViewModel>(context).errorMsg;
    if (_memberErrMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
    }

    if (_policeReports != null) {
      if (_caseProgress == null) {
        this._setupFilterData();
      }
    }

    if (_subRegions != null) {
      if (this._policeReportFilterWidget == null) {
        this._policeReportFilterWidget._caseProgress = _caseProgress ?? [];
        this._policeReportFilterWidget._units = _units ?? [];
        this._policeReportFilterWidget._members = _members ?? [];
        this._policeReportFilterWidget._regions = _regions ?? [];
        this._policeReportFilterWidget._subRegions = _subRegions ?? [];
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Laporan Polisi',
          showSearchBar: true,
          searchBarHint: 'Masukkan Kata Kunci',
          searchCont: searchCont,
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              onPressed: () => showBarModalBottomSheet(
                context: context,
                builder: (context) {
                  return this._policeReportFilterWidget;
                },
              ),
            ),
          ],
        ),
        body: ListView.separated(
          controller: this._scrollController,
          padding: EdgeInsets.only(top: 8),
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
            height: 1,
            indent: 24,
          ),
          itemCount: (!_isLoading) ? _policeReports.length + ((this._currentPage < this._totalPage) ? 1 : 0) : 10,
          itemBuilder: (context, index) {
            if (_isLoading) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ShimmerWidget(),
              );
            }

            if (index > (_policeReports.length - 1)) {
              return PaginationLoadingWidget();
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => PoliceReportDetail(policeReportId: _policeReports[index].id),
                  ),
                );
              },
              child: _buildPoliceReportItem(policeReport: _policeReports[index]),
            );
          },
        ),
      ),
    );
  }

  @override
  void filterPoliceReportData({
    CaseProgress caseProgress,
    String isAttention,
    Unit unit,
    Member member,
    Region region,
    SubRegion subRegion,
  }) {
    this._selectedCaseProgress = caseProgress;
    this._selectedMember = member;
    this._selectedRegion = region;
    this._selectedSubRegion = subRegion;

    Provider.of<PoliceReportViewModel>(context, listen: false).resetPoliceReport();
    setState(() {
      this._isLoading = true;
    });
    PoliceReportViewModel.shared.getAllPoliceReport(
      searchQuery: this._searchQuery,
      page: this._currentPage,
      caseProgressId: (caseProgress != null) ? caseProgress.id : null,
      isAttention: isAttention,
      unit: (unit != null) ? unit.id : null,
      memberId: (member != null) ? member.id : null,
      regionCode: (region != null) ? region.regionCode : null,
      subRegionId: (subRegion != null) ? subRegion.id : null,
    );
  }
}

// ignore: must_be_immutable
class PoliceReportFilterWidget extends StatelessWidget implements WheelPickerDelegate {
  PoliceReportDelegate _delegate;

  List<CaseProgress> _caseProgress = [];
  List<Unit> _units = [];
  List<Member> _members = [];
  List<Region> _regions = [];
  List<SubRegion> _subRegions = [];

  List<String> _caseProgressContents = [];
  List<String> _attentionContents = ['Semua', 'Ya', 'Tidak'];
  List<String> _unitContents = [];
  List<String> _memberConstants = [];
  List<String> _regionContents = [];
  List<String> _subRegionContents = [];

  WheelPickerWidget _caseProgressPicker;
  WheelPickerWidget _attentionPicker;
  WheelPickerWidget _unitPicker;
  WheelPickerWidget _memberPicker;
  WheelPickerWidget _regionPicker;
  WheelPickerWidget _subRegionPicker;

  CaseProgress _selectedCaseProgress;
  String _selectedAttention;
  Unit _selectedUnit;
  Member _selectedMember;
  Region _selectedRegion;
  SubRegion _selectedSubRegion;

  PoliceReportFilterWidget(
    this._delegate, {
    List<CaseProgress> caseProgress = const [],
    List<Unit> units = const [],
    List<Member> members = const [],
    List<Region> regions = const [],
    List<SubRegion> subRegions = const [],
  }) {
    //* Setup case progress filter
    this._caseProgressPicker = WheelPickerWidget(contentList: this._caseProgressContents, delegate: this);

    //* Setup attention filter
    this._selectedAttention = this._attentionContents[0];
    this._attentionPicker = WheelPickerWidget(contentList: this._attentionContents, delegate: this);

    //* Setup unit filter
    this._unitPicker = WheelPickerWidget(contentList: this._unitContents, delegate: this);

    //* Setup member filter
    this._memberPicker = WheelPickerWidget(contentList: this._memberConstants, delegate: this);

    //* Setup region filter
    this._regionPicker = WheelPickerWidget(contentList: this._regionContents, delegate: this);

    //* Setup sub region filter
    this._subRegionPicker = WheelPickerWidget(contentList: this._subRegionContents, delegate: this);
  }

  @override
  Widget build(BuildContext context) {
    List<CaseProgress> _caseProgress = Provider.of<PoliceReportViewModel>(context).caseProgress;
    List<Unit> _units = Provider.of<PoliceReportViewModel>(context).units;
    List<Member> _members = Provider.of<MemberViewModel>(context).members;
    List<Region> _regions = Provider.of<PoliceReportViewModel>(context).regions;
    List<SubRegion> _subRegions = Provider.of<PoliceReportViewModel>(context).subRegions;

    if (_caseProgress != null) {
      this._caseProgress.clear();
      this._caseProgress.addAll(_caseProgress);
      if (this._caseProgress.length < (_caseProgress.length + 1)) {
        this._caseProgress.insert(0, CaseProgress(id: null, name: 'Semua'));
      }
      if (this._caseProgress.length >= 0 && this._selectedCaseProgress == null) {
        this._selectedCaseProgress = this._caseProgress[0];
      }
      this._caseProgressContents = this._caseProgress.map((e) => e.name).toList();
      _caseProgressPicker.contentList = this._caseProgressContents;
    }

    if (_units != null) {
      this._units.clear();
      this._units.addAll(_units);
      if (this._units.length < (_units.length + 1)) {
        this._units.insert(0, Unit(id: null, name: 'Semua'));
      }
      if (this._units.length > 0 && this._selectedUnit == null) {
        this._selectedUnit = this._units[0];
      }
      this._unitContents = this._units.map((e) => e.name).toList();
      _unitPicker.contentList = this._unitContents;
    }

    if (_members != null) {
      this._members.clear();
      this._members.addAll(_members);
      if (this._members.length < (_members.length + 1)) {
        this._members.insert(0, Member(id: null, fullName: 'Semua'));
      }
      if (this._members.length >= 0 && this._selectedMember == null) {
        this._selectedMember = this._members[0];
      }
      this._memberConstants = this._members.map((e) => e.fullName).toList();
      _memberPicker.contentList = this._memberConstants;
    }

    if (_regions != null) {
      this._regions.clear();
      this._regions.addAll(_regions);
      if (this._regions.length < (_regions.length + 1)) {
        this._regions.insert(0, Region(id: null, name: 'Semua'));
      }
      if (this._regions.length > 0 && this._selectedRegion == null) {
        this._selectedRegion = this._regions[0];
      }
      this._regionContents = this._regions.map((e) => e.name).toList();
      _regionPicker.contentList = this._regionContents;
    }

    if (_subRegions != null) {
      this._subRegions.clear();
      this._subRegions.addAll(_subRegions);
      if (this._subRegions.length < (_subRegions.length + 1)) {
        this._subRegions.insert(0, SubRegion(id: null, name: 'Semua'));
      }
      if (this._subRegions.length > 0 && this._selectedSubRegion == null) {
        this._selectedSubRegion = this._subRegions[0];
      }
      this._subRegionContents = this._subRegions.map((e) => e.name).toList();
      _subRegionPicker.contentList = this._subRegionContents;
    }

    return Container(
      child: Wrap(
        runSpacing: 16,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Wrap(
              runSpacing: 16,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _buildTextAlignLeft(
                    text: 'Filter',
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 16,
                    children: [
                      customTextFieldGroup(
                        context: context,
                        labelText: 'Progress Perkara',
                        isSecured: false,
                        isDropdown: true,
                        value: (this._selectedCaseProgress != null) ? this._selectedCaseProgress.name : '',
                        inputView: this._caseProgressPicker,
                      ),
                      customTextFieldGroup(
                        context: context,
                        labelText: 'Jenis Atensi',
                        isSecured: false,
                        isDropdown: true,
                        value: (this._selectedAttention != null) ? this._selectedAttention : '',
                        inputView: this._attentionPicker,
                      ),
                      customTextFieldGroup(
                        context: context,
                        labelText: 'Unit',
                        isSecured: false,
                        isDropdown: true,
                        value: (this._selectedUnit != null) ? this._selectedUnit.name : '',
                        inputView: this._unitPicker,
                      ),
                      customTextFieldGroup(
                        context: context,
                        labelText: 'Penyidik',
                        isSecured: false,
                        isDropdown: true,
                        value: (this._selectedMember != null) ? this._selectedMember.fullName : '',
                        inputView: this._memberPicker,
                      ),
                      customTextFieldGroup(
                        context: context,
                        labelText: 'Wilayah',
                        isSecured: false,
                        isDropdown: true,
                        value: (this._selectedRegion != null) ? this._selectedRegion.name : '',
                        inputView: this._regionPicker,
                      ),
                      customTextFieldGroup(
                        context: context,
                        labelText: 'Sub Wilayah',
                        isSecured: false,
                        isDropdown: true,
                        value: (this._selectedSubRegion != null) ? this._selectedSubRegion.name : '',
                        inputView: this._subRegionPicker,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 25,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'Terapkan',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: (_subRegions == null) ? AppColor.TEXT_MUTED_COLOR : Colors.white),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>((_subRegions == null) ? AppColor.MUTED_BTN_COLOR : AppColor.PRIMARY_COLOR)),
                onPressed: () {
                  if (_subRegions == null) {
                    return;
                  }

                  this._delegate.filterPoliceReportData(
                        caseProgress: this._selectedCaseProgress,
                        isAttention: this._selectedAttention,
                        member: this._selectedMember,
                        unit: this._selectedUnit,
                        region: this._selectedRegion,
                        subRegion: this._selectedSubRegion,
                      );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didSelectItem(int index, WheelPickerWidget pickerView, BuildContext context) {
    if (pickerView == this._caseProgressPicker) {
      print(this._caseProgress[index]);
      this._selectedCaseProgress = this._caseProgress[index];
    } else if (pickerView == this._attentionPicker) {
      this._selectedAttention = this._attentionContents[index];
    } else if (pickerView == this._unitPicker) {
      this._selectedUnit = this._units[index];
    } else if (pickerView == this._memberPicker) {
      this._selectedMember = this._members[index];
    } else if (pickerView == this._regionPicker) {
      this._selectedRegion = this._regions[index];
      Provider.of<PoliceReportViewModel>(context, listen: false).getAllSubRegion(regionCode: this._selectedRegion.regionCode);
    } else if (pickerView == this._subRegionPicker) {
      this._selectedSubRegion = this._subRegions[index];
    }
  }
}
