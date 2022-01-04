import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//* unused import
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:subditharda_apel/models/attendance_model.dart';

import '../api_service.dart';

class AttendanceViewModel with ChangeNotifier {
  // static final shared = PrisonerViewModel();

  ApiResponse _apiResponse;
  List<Attendance> attendances;
  int _totalPage = 0;
  bool _isSuccess = false;

  String _errMsg;

  bool get isSuccess {
    return _isSuccess;
  }

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  String get errorMsg {
    return _errMsg;
  }

  int get totalPage {
    return _totalPage;
  }

  AttendanceViewModel() {
    // this.prisoners = null;
    this._errMsg = null;
  }

  Future<void> getAllAttendance({int page = 1}) async {
    //* Check if it's first load for pagination
    this._errMsg = null;

    final apiService = APIService(endPoint: '/api/mobile/v1/absensi/list', isPrivate: true);
    final response = await apiService.get(query: {
      'page': page.toString(),
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    final _attendances = List<Attendance>.from((response.data['data'] as List).map((e) => Attendance.fromJson(e)));

    //* Prisoners handler for pagination
    if (page == 1) {
      this.attendances = _attendances;
      this._totalPage = apiResponse.data['last_page'];
    } else {
      this.attendances.addAll(_attendances);
    }

    inspect(this.attendances);

    notifyListeners();
  }

  Future createAttendance({
    @required String tanggalAbsensi,
    @required String tipePresensi,
    @required String keterangan,
    @required LocationData locationData,
    File selfieWajah,
  }) async {
    final apiService = APIService(endPoint: '/api/mobile/v1/absensi/create', isPrivate: true);
    final response = await apiService.upload(body: {
      'tanggal_absensi': tanggalAbsensi,
      'presensi': tipePresensi,
      'keterangan': keterangan,
      'latitude': locationData.latitude.toString(),
      'longitude': locationData.longitude.toString(),
    }, multipartFiles: {
      'foto': selfieWajah
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      this._isSuccess = false;
      notifyListeners();
      return;
    }

    this._isSuccess = true;
    notifyListeners();
  }

  void prepareNewAttendance() => this._isSuccess = false;

  void reset() {
    this.attendances = null;
    this._errMsg = null;
  }
}
