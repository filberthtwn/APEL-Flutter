import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/models/default_resp_model.dart';
import 'package:subditharda_apel/models/user_model.dart';

import '../api_service.dart';

class MessageViewModel with ChangeNotifier {
  static final shared = MessageViewModel();

  ApiResponse _createRoomResp;
  ApiResponse get createRoomResp {
    return _createRoomResp;
  }

  ApiResponse _getMessagesResp;
  ApiResponse get getMessagesResp {
    return _getMessagesResp;
  }

  ApiResponse _sendMessageResp;
  ApiResponse get sendMessageResp {
    return _sendMessageResp;
  }

  String _errMsg;
  String get errorMsg {
    return _errMsg;
  }

  Future<void> createRoom({
    @required String receiverId,
  }) async {
    this._getMessagesResp = null;
    User _user = SharedPrefHelper.shared.user;

    final apiService = APIService(endPoint: '/api/mobile/v1/chats/create_room', isPrivate: true);
    final body = {
      "sender_id": _user.id,
      "receiver_id": receiverId,
    };
    final response = await apiService.post(body: body);

    final apiResponse = APIHelper.shared.checkResponse(response);
    // if (!apiResponse.success) {
    //   _errMsg = apiResponse.message;
    //   notifyListeners();
    //   return;
    // }
    this._createRoomResp = apiResponse;

    notifyListeners();
  }

  Future<void> sendMessage({
    @required String receiverId,
    String message,
    File image,
    @required String type,
  }) async {
    DefaultResp response;
    User _user = SharedPrefHelper.shared.user;

    final jsonMessage = {
      "fields": {
        "text": {
          "stringValue": message,
        },
        "type": {
          "stringValue": type,
        }
      }
    };

    final apiService = APIService(endPoint: '/api/mobile/v1/chats/send_message', isPrivate: true);
    Map<String, String> body = {
      "sender_id": _user.id,
      "receiver_id": receiverId,
      "message_type": type
    };

    if (type == 'text'){
      body["messages"] = jsonEncode(jsonMessage);
      response = await apiService.post(body: body);
    }

    if (type == 'image'){
      final multipartFiles  = {
        "message_file": image
      };

      print(body);
      print(multipartFiles);

      response = await apiService.upload(body: body, multipartFiles: multipartFiles);
    }



    final apiResponse = APIHelper.shared.checkResponse(response);
    this._sendMessageResp = apiResponse;

    notifyListeners();
  }

  Future<void> getMessages({
    @required String receiverId,
  }) async {
    this._getMessagesResp = null;
    User _user = SharedPrefHelper.shared.user;

    final apiService = APIService(endPoint: '/api/mobile/v1/chats/get_message', isPrivate: true);
    final query = {
      'sender_id': _user.id,
      'receiver_id': receiverId,
    };
    final response = await apiService.get(query: query);

    final apiResponse = APIHelper.shared.checkResponse(response);
    if (!apiResponse.success) {
      _errMsg = apiResponse.message;
      notifyListeners();
      return;
    }
    apiResponse.data["fields"] = apiResponse.data["fields"].reversed.toList();
    this._getMessagesResp = apiResponse;
    inspect(apiResponse);

    notifyListeners();
  }

  Future<void> reset() async {
    this._createRoomResp = null;
    this._getMessagesResp = null;
    this._sendMessageResp = null;
  }

  Future<void> resetCreateRoomResp() async {
    this._createRoomResp = null;
  }

  Future<void> resetSendMessageResp() async {
    this._sendMessageResp = null;
  }
}
