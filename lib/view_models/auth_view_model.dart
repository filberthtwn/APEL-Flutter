//* unused import
// import 'package:provider/provider.dart';
// import 'package:subditharda_apel/models/default_resp_model.dart';

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/models/user_model.dart';

import '../api_service.dart';

class AuthViewModel with ChangeNotifier {
  static final shared = AuthViewModel();

  ApiResponse _apiResponse;

  String _successMsg;
  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  String get successMsg {
    return _successMsg;
  }

  String get errorMsg {
    return _errMsg;
  }

  AuthViewModel() {
    this._apiResponse = null;
    this._errMsg = null;
  }

  Future<void> login({@required String email, @required String password, @required String fcmToken}) async {
    final body = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken
    };
    print(body);

    final apiService = APIService(endPoint: '/api/mobile/v1/anggota/login', isPrivate: false);
    final defaultResp = await apiService.post(body: body);

    final apiResponse = APIHelper.shared.checkResponse(defaultResp, isPrivate: false);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    //* Save token to SharedPref
    await SharedPrefHelper.shared.setToken(token: apiResponse.data['data']['auth_code']);
    print(await SharedPrefHelper.shared.getToken());

    //* Save user id to SharedPref
    final user = new User(id: apiResponse.data['data']['user_id']);
    await SharedPrefHelper.shared.setCurrentUser(encodedUser: json.encode(user.toJson()));
    inspect(await SharedPrefHelper.shared.getCurrentUser());

    this._apiResponse = apiResponse;

    notifyListeners();
  }

  Future<void> changePassword({@required String oldPassword, @required String newPassword}) async {
    final apiService = APIService(endPoint: '/api/mobile/v1/anggota/change_password', isPrivate: true);
    final defaultResp = await apiService.put(body: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });

    final apiResponse = APIHelper.shared.checkResponse(defaultResp, isPrivate: false);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._successMsg = apiResponse.message;

    notifyListeners();
  }

  void resetErrMsg() {
    this._errMsg = null;
  }

  void reset() {
    this._apiResponse = null;
    this._successMsg = null;
    this._errMsg = null;
  }
}
