import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/models/notification_model.dart';

import '../api_service.dart';

class NotificationViewModel with ChangeNotifier {
  static final shared = NotificationViewModel();

  ApiResponse _apiResponse;
  List<Notif> notifications;
  int _totalPage = 0;

  Notif notification;

  String _errMsg;

  //* Getter
  ApiResponse get apiResponse => this._apiResponse;
  String get errorMsg => this._errMsg;
  int get totalPage => this._totalPage;

  NotificationViewModel() {
    this._errMsg = null;
  }

  Future<void> getAllNotification({int page = 1}) async {
    //* Check if it's first load for pagination
    this._errMsg = null;
    final apiService = APIService(
        endPoint: '/api/mobile/v1/notification/list', isPrivate: true);
    final response = await apiService.get(query: {
      'page': page.toString(),
    });

    final apiResponse = APIHelper.shared.checkResponse(response);

    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }
    final notifications = List<Notif>.from(
        (response.data['data'] as List).map((e) => Notif.fromJson(e)));

    //* Members handler for pagination
    if (page == 1) {
      this.notifications = notifications;
      this._totalPage = apiResponse.data['last_page'];
    } else {
      this.notifications.addAll(notifications);
    }

    inspect(this.notifications);

    notifyListeners();
  }

  void reset() {
    this.notifications = null;
    this._errMsg = null;
  }
}
