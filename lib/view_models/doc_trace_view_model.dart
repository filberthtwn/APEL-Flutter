//* unused import
// import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/models/doc_trace_model.dart';

import '../api_service.dart';

class DocTraceViewModel with ChangeNotifier {
  static final shared = DocTraceViewModel();

  ApiResponse _apiResponse;
  List<Document> documents;
  Document document;
  Map<String, dynamic> _docSummary;

  bool _isSuccess = false;
  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  bool get isSuccess {
    return _isSuccess;
  }

  String get errorMsg {
    return _errMsg;
  }

  Map<String, dynamic> get docSummary {
    return _docSummary;
  }

  set docSummary(Map<String, dynamic> docSummary) {
    _docSummary = docSummary;
  }

  void resetErrMsg() {
    _errMsg = null;
  }

  DocTraceViewModel() {
    // this.policeReports = null;
    this.document = null;
    this._errMsg = null;
  }

  Future<void> getAllDocTrace({String searchQuery, String page}) async {
    this.documents = null;
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/berkas/list', isPrivate: true);
    final response = await apiService.get(query: {
      'keywords': searchQuery,
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this.documents = List<Document>.from((response.data['data'] as List).map((e) => Document.fromJson(e)));

    inspect(this.documents);

    notifyListeners();
  }

  Future<void> getDocumentDetail({@required String id}) async {
    this.document = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/berkas/view/$id', isPrivate: true);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }
    this.document = Document.fromJson(apiResponse.data);

    inspect(this.document);
    notifyListeners();
  }

  Future<void> verifyDocument({@required String id}) async {
    final apiService = APIService(endPoint: '/api/mobile/v1/berkas/verify/$id', isPrivate: true);

    Map<String, dynamic> body = {
      "status_verify": "approved",
      "notes": "Berkas Telah Disetujui",
    };

    final response = await apiService.put(body: body);

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._apiResponse = apiResponse;
    this._isSuccess = true;
    notifyListeners();
  }

  Future<void> getDocRepotSummary({@required String year}) async {
    final apiService = APIService(endPoint: '/api/mobile/v1/laporan_polisi/total_berkas', isPrivate: true);

    Map<String, dynamic> query = {
      "year": year,
    };

    print(query);

    final response = await apiService.get(query: query);
    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._docSummary = apiResponse.data;
    notifyListeners();
  }

  void resetIsSuccess() {
    this._isSuccess = false;
  }

  void reset() {
    this._apiResponse = null;
  }
}
