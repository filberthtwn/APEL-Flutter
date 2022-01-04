//* unused import
// import 'package:dio/dio.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/models/attention_model.dart';
import 'package:subditharda_apel/models/case_progress_model.dart';
import 'package:subditharda_apel/models/police_report_model.dart';
import 'package:subditharda_apel/models/region_model.dart';
import 'package:subditharda_apel/models/subregion_model.dart';
import 'package:subditharda_apel/models/unit_model.dart';

import '../api_service.dart';

class PoliceReportViewModel with ChangeNotifier {
  static final shared = PoliceReportViewModel();

  ApiResponse _apiResponse;
  List<PoliceReport> _policeReports = [];
  List<SummaryLocationReport> _summaryLocationReports = [];
  int _totalPage = 0;
  PoliceReport policeReport;
  String _filePath;

  List<CaseProgress> _caseProgress;
  List<Attention> _attentions;
  List<Unit> _units;
  List<Region> _regions;
  List<SubRegion> _subRegions;

  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  int get totalPage {
    return _totalPage;
  }

  List<SummaryLocationReport> get summaryLocationReports {
    return _summaryLocationReports;
  }

  List<PoliceReport> get policeReports {
    return _policeReports;
  }

  List<CaseProgress> get caseProgress {
    return _caseProgress;
  }

  List<Unit> get units => _units;
  List<Region> get regions => _regions;
  List<SubRegion> get subRegions => _subRegions;

  String get filePath {
    return _filePath;
  }

  List<Attention> get attentions => _attentions;

  String get errorMsg {
    return _errMsg;
  }

  PoliceReportViewModel() {
    // this.policeReports = null;
    this._policeReports = null;
    this.policeReport = null;
    this._errMsg = null;
  }

  Future<void> getAllSummaryLocationReport() async {
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/laporan_polisi/summary_location', isPrivate: true);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    final summaryLocationReports = List<SummaryLocationReport>.from((response.data['data'] as List).map((e) => SummaryLocationReport.fromJson(e)));
    this._summaryLocationReports = summaryLocationReports;

    notifyListeners();
  }

  Future<void> getAllPoliceReport({
    @required String searchQuery,
    int page = 1,
    String caseProgressId,
    String isAttention,
    String unit,
    String memberId,
    String regionCode,
    String subRegionId,
  }) async {
    this._errMsg = null;

    Map<String, dynamic> query = {
      'keywords': searchQuery,
      'page': page.toString(),
    };

    if (caseProgressId != null) {
      query['progress_perkara'] = caseProgressId;
    }

    if (isAttention != null) {
      if (isAttention == 'Ya') {
        query['is_atensi'] = 'Y';
      } else if (isAttention == 'Tidak') {
        query['is_atensi'] = 'N';
      }
    }

    if (unit != null) {
      query['unit'] = unit;
    }

    if (memberId != null) {
      query['anggota'] = memberId;
    }

    if (regionCode != null) {
      query['wilayah'] = regionCode;
    }

    if (subRegionId != null) {
      query['sub_wilayah'] = subRegionId;
    }

    final apiService = APIService(endPoint: '/api/mobile/v1/laporan_polisi/list', isPrivate: true);
    final response = await apiService.get(query: query);

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    final policeReports = List<PoliceReport>.from((response.data['data'] as List).map((e) => PoliceReport.fromJson(e)));
    if (page > 1) {
      this.policeReports.addAll(policeReports);
    } else {
      this._totalPage = apiResponse.data['last_page'];
      print('TOTAL PAGE: ${this._totalPage}');
      this._policeReports = policeReports;
    }

    notifyListeners();
  }

  Future<void> getPoliceReportDetail({@required String id}) async {
    this.policeReport = null;

    final user = await SharedPrefHelper.shared.getCurrentUser();
    final apiService = APIService(endPoint: '/api/mobile/v1/laporan_polisi/view/$id', isPrivate: true);
    final response = await apiService.get(query: {
      'user_id': user.id,
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }
    this.policeReport = PoliceReport.fromJson(apiResponse.data);
    inspect(this.policeReport);
    notifyListeners();
  }

  Future<void> getAllCaseProgress() async {
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/master-data/progress-perkara', isPrivate: false);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._caseProgress = List<CaseProgress>.from((response.data['data'] as List).map((e) => CaseProgress.fromJson(e)));
    inspect(this._caseProgress);

    notifyListeners();
  }

  Future<void> getAllAttention() async {
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/master-data/atensi', isPrivate: false);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._attentions = List<Attention>.from((response.data['data'] as List).map((e) => Attention.fromJson(e)));
    inspect(this._attentions);

    notifyListeners();
  }

  Future<void> getAllUnit() async {
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/master-data/unit_anggota', isPrivate: false);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._units = List<Unit>.from((response.data['data'] as List).map((e) => Unit.fromJson(e)));
    inspect(this._units);

    notifyListeners();
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getTemporaryDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }

  Future<void> downloadPoliceReport({String policeReportId}) async {
    this._errMsg = null;

    //* final uri = Uri.parse(
    //*     'https://staging.subdithardapmj.com/api/mobile/v1/export/laporan_polisi/detail/pdf/$policeReportId');

    this._filePath = await getFilePath('abc');
    try {
      //* final response = await Dio().download(
      //*   'https://staging.subdithardapmj.com/api/mobile/v1/export/laporan_polisi/detail/pdf/$policeReportId',
      //*   this._filePath,
      //* );
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> getAllRegion({String policeReportId}) async {
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/master-data/wilayah', isPrivate: false);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._regions = List<Region>.from((response.data['data'] as List).map((e) => Region.fromJson(e)));
    inspect(this._regions);

    notifyListeners();
  }

  Future<void> getAllSubRegion({@required String regionCode}) async {
    this._subRegions = null;
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/master-data/sub_wilayah', isPrivate: false);
    final response = await apiService.get(query: {
      'kode_wilayah': regionCode,
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._subRegions = List<SubRegion>.from((response.data['data'] as List).map((e) => SubRegion.fromJson(e)));
    inspect(this._subRegions);

    notifyListeners();
  }

  void reset() {
    this._policeReports = null;
    this._caseProgress = null;
    this._attentions = null;
  }

  void resetPoliceReport() {
    this._policeReports = null;
  }

  void resetFilePath() {
    this._filePath = null;
  }
}
