//* unused import
// import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
// import 'package:subditharda_apel/models/doc_trace_model.dart';

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/models/banner_model.dart';

import '../api_service.dart';

class BannerViewModel with ChangeNotifier {
  static final shared = BannerViewModel();

  ApiResponse _apiResponse;
  List<Banner> _banners;

  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  List<Banner> get banners {
    return this._banners;
  }

  String get errorMsg {
    return _errMsg;
  }

  Future<void> getAllBanner() async {
    // this.documents = null;
    this._errMsg = null;

    final apiService =
        APIService(endPoint: '/api/mobile/v1/banner', isPrivate: false);
    final response = await apiService.get(query: {});

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._banners = List<Banner>.from(
        (response.data['data'] as List).map((e) => Banner.fromJson(e)));

    inspect(this._banners);

    notifyListeners();
  }
}
