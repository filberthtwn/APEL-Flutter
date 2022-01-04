import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/models/user_model.dart';
import 'package:device_info/device_info.dart';

import '../api_service.dart';

class UserViewModel with ChangeNotifier {
  static final shared = UserViewModel();

  ApiResponse _apiResponse;
  int _totalPage = 0;
  bool _isSuccess = false;
  bool _isAddDeviceSuccess = false;

  User user;

  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  bool get isSuccess {
    return _isSuccess;
  }

  bool get isAddDeviceSuccess {
    return _isAddDeviceSuccess;
  }

  String get errorMsg {
    return _errMsg;
  }

  int get totalPage {
    return _totalPage;
  }

  UserViewModel() {
    // this.prisoners = null;
    this._errMsg = null;
  }

  Future<void> getUserDetail() async {
    this.user = null;

    final user = await SharedPrefHelper.shared.getCurrentUser();
    final apiService = APIService(endPoint: '/api/mobile/v1/anggota/profile', isPrivate: true);
    final response = await apiService.get(query: {
      'user_id': user.id,
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }
    inspect(apiResponse.data);
    this.user = User.fromJson(apiResponse.data);
    await SharedPrefHelper.shared.setCurrentUser(encodedUser: json.encode(this.user.toJson()));
    inspect(await SharedPrefHelper.shared.getCurrentUser());

    notifyListeners();
  }

  Future updateUser({
    @required String fullName,
    @required String nrpNumber,
    @required String email,
    @required String phoneNumber,
    @required String gender,
    @required String birthdate,
    File image,
  }) async {
    final apiService = APIService(endPoint: '/api/mobile/v1/anggota/save_profile', isPrivate: true);
    final response = await apiService.upload(body: {
      'nama_lengkap': fullName,
      'nrp': nrpNumber,
      'email': email,
      'nomor_telepon': "081332221998",
      'jenis_kelamin': gender,
      'tanggal_lahir': birthdate,
    }, multipartFiles: {
      'foto': image
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._isSuccess = true;
    notifyListeners();
  }

  Future addDevice({
    @required String fcmToken
  }) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final body = {
      'uuid': androidInfo.androidId,
      'token': fcmToken,
      'type': 'android',
      'os': 'Android ' + androidInfo.version.release,
      'model': androidInfo.model,
    };

    final apiService = APIService(endPoint: '/api/mobile/v1/device/create', isPrivate: true);
    final response = await apiService.post(body: body);

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    this._isAddDeviceSuccess = true;
    notifyListeners();
  }

  resetErrMsg() {
    this._errMsg = null;
  }

  resetAddDevice() {
    this._isAddDeviceSuccess = false;
  }

  reset() {
    this._isSuccess = false;
    this._isAddDeviceSuccess = false;
    this._apiResponse = null;
    this._errMsg = null;
    this.user = null;
  }
}
