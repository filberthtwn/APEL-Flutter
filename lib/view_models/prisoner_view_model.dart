import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/models/prisoner_model.dart';

import '../api_service.dart';

class PrisonerViewModel with ChangeNotifier {
  // static final shared = PrisonerViewModel();

  ApiResponse _apiResponse;
  // bool isLoaded = false;
  List<Prisoner> prisoners;
  int _totalPage = 0;

  Prisoner prisoner;

  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  String get errorMsg {
    return _errMsg;
  }

  int get totalPage {
    return _totalPage;
  }

  PrisonerViewModel() {
    // this.prisoners = null;
    this._errMsg = null;
  }

  Future<void> getAllPrisoner({@required String searchQuery, int page = 1}) async {
    //* Check if it's first load for pagination
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/tahanan/list', isPrivate: true);
    final response = await apiService.get(query: {
      'keywords': searchQuery,
      'page': page.toString(),
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    final prisoners = List<Prisoner>.from((response.data['data'] as List).map((e) => Prisoner.fromJson(e)));

    //* Prisoners handler for pagination
    if (page == 1) {
      this.prisoners = prisoners;
      this._totalPage = apiResponse.data['last_page'];
    } else {
      this.prisoners.addAll(prisoners);
    }

    inspect(this.prisoners);

    notifyListeners();
  }

  void reset() {
    this.prisoners = null;
    this._errMsg = null;
  }

  // Future<void> getPoliceReportDetail({@required String id}) async {
  //   this.policeReport = null;

  //   final user = await SharedPrefHelper.shared.getCurrentUser();
  //   final apiService = APIService(endPoint: '/api/mobile/v1/laporan_polisi/view/$id', isPrivate: true);
  //   final response = await apiService.get(query: {
  //     'user_id': user.id,
  //   });

  //   final apiResponse = APIHelper.shared.checkResponse(response);

  //   if (!apiResponse.success) {
  //     _errMsg = apiResponse.message;
  //     notifyListeners();
  //     return;
  //   }
  //   this.policeReport = PoliceReport.fromJson(apiResponse.data);
  //   notifyListeners();
  // }
}
