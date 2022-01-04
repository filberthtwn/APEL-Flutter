//* unused import
// import 'dart:developer';
// import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
// import 'package:subditharda_apel/models/banner_model.dart';
// import 'package:subditharda_apel/models/doc_trace_model.dart';

import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/models/member_activity_model.dart';

import '../api_service.dart';

class CalendarViewModel with ChangeNotifier {
  static final shared = CalendarViewModel();

  ApiResponse _apiResponse;
  List<MemberActivity> _memberDuties;
  List<MemberActivity> _memberActivites;

  //* Today activities
  List<MemberActivity> _todayMemberDuties;
  List<MemberActivity> _todayMemberActivites;

  String _errMsg;

  ApiResponse get apiResponse {
    return _apiResponse;
  }

  List<MemberActivity> get memberDuties {
    return this._memberDuties;
  }

  List<MemberActivity> get memberActivites {
    return this._memberActivites;
  }

  List<MemberActivity> get todayMemberDuties {
    return this._todayMemberDuties;
  }

  List<MemberActivity> get todayMemberActivites {
    return this._todayMemberActivites;
  }

  String get errorMsg {
    return _errMsg;
  }

  Future<void> getAllAgenda({
    @required String startDate,
    @required String endDate,
    @required String type,
  }) async {
    this._errMsg = null;

    final apiService = APIService(
        endPoint: '/api/mobile/v1/agenda/list_agenda', isPrivate: true);
    final response = await apiService.get(query: {
      'start_date': startDate,
      'end_date': endDate,
      'tab': type,
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }

    if (type == 'piket') {
      if (startDate == endDate) {
        this._todayMemberDuties = List<MemberActivity>.from(
            (response.data['data'] as List)
                .map((e) => MemberActivity.fromJson(e)));
      } else {
        this._memberDuties = List<MemberActivity>.from(
            (response.data['data'] as List)
                .map((e) => MemberActivity.fromJson(e)));
      }
    } else {
      if (startDate == endDate) {
        this._todayMemberActivites = List<MemberActivity>.from(
            (response.data['data'] as List)
                .map((e) => MemberActivity.fromJson(e)));
      } else {
        this._memberActivites = List<MemberActivity>.from(
            (response.data['data'] as List)
                .map((e) => MemberActivity.fromJson(e)));
      }
    }
    notifyListeners();
  }

  void reset() {
    this._memberDuties = null;
    this._memberActivites = null;

    this._todayMemberDuties = null;
    this._todayMemberActivites = null;
  }

  void resetActivities() {
    this._memberDuties = null;
    this._memberActivites = null;
  }

  void resetTodayActivites() {
    this._todayMemberDuties = null;
    this._todayMemberActivites = null;
  }
}
