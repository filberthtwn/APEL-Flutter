import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
//* unused import
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:subditharda_apel/ui/pages/pages.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/main.dart';

import 'constants/constants.dart';
import 'models/default_resp_model.dart';

class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  ApiResponse({
    @required this.success,
    @required this.message,
    @required this.data,
  });
}

class APIHelper with ChangeNotifier {
  static final shared = APIHelper();
  bool isLoggedOut = false;

  APIHelper() {
    this.isLoggedOut = false;
  }

  ApiResponse checkResponse(DefaultResp response, {bool isPrivate}) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
      case 201:
        return (new ApiResponse(success: true, message: response.message, data: response.data));
        break;
      case 401:
        if (isPrivate == null) {
          Navigator.of(App.shared.context).pushReplacementNamed('/login');
          return (new ApiResponse(success: false, message: 'Mohon login kembali', data: response.data));
        }
        return (new ApiResponse(success: false, message: response.message, data: response.data));
        break;
      case 500:
        return (new ApiResponse(success: false, message: "Something wroing with the server", data: response.data));
      default:
        return (new ApiResponse(success: false, message: response.message, data: response.data));
    }
  }
}

class APIService {
  final String _baseUrl = Constants.BASE_URL.replaceAll('https://', '');
  // final String _baseUrl = 'staging.subdithardapmj.com';

  final String endPoint;
  final bool isPrivate;

  Uri _url;

  List<File> files = [];
  Map<String, String> _headers;
  /*
   * Default Constructor
  */
  APIService({this.endPoint, this.isPrivate}) {
    //* Setup final endpoint url
    _url = Uri.https(this._baseUrl, this.endPoint);
    log(_url.toString());
  }

  /*
    * Get Request Handler
    *
    * Get default
    * API_Service(endpoint: 'api/v1/example_route', isPrivate: Bool)
    *
    * Get with params
    * API_Service(endpoint: 'api/v1/example_route/$user_id', isPrivate: Bool)
    *
    * Get with query
    * API_Service(endpoint: 'api/v1/example_route', isPrivate: Bool, params: {'example_key':'example_value'})
  */

  Future<DefaultResp> get({@required Map<String, dynamic> query}) async {
    //* Init token if private API
    if (this.isPrivate) await setupAuthCode(query);

    this._url = Uri.https(this._baseUrl, this.endPoint, query);

    //* Do request to server
    final response = await http.get(this._url, headers: this._headers);
    //* Call response handler function
    return this._resposeHandler(response);
  }

  /*
   * Post Request Handler
  */
  Future<DefaultResp> post({@required Map<String, dynamic> body}) async {
    Map<String, dynamic> query = {};
    //* Init token if private API
    if (this.isPrivate) {
      query = await setupAuthCode({});
    }

    this._url = Uri.https(this._baseUrl, this.endPoint, query);
    print(this._url);

    //* Do request to server
    Map<String, String> castedBody = {'': ''};
    body.forEach((key, value) {
      castedBody[key] = value.toString();
    });

    final jsonEncoded = (new JsonEncoder.withIndent("   ")).convert(castedBody);
    log('BODY =>');
    log(jsonEncoded);

    final response = await http.post(this._url, headers: this._headers, body: castedBody);

    //* Call response handler function
    return this._resposeHandler(response);
  }

  /*
   * Patch Request Handler
  */
  Future<DefaultResp> patch({@required Map<String, dynamic> body}) async {
    //* Init token if private API
    if (this.isPrivate) await setupHeader();

    //* Do request to server
    final response = await http.patch(this._url, headers: this._headers, body: body);

    //* Call response handler function
    return this._resposeHandler(response);
  }

  /*
   * Patch Request Handler
  */
  Future<DefaultResp> put({@required Map<String, dynamic> body}) async {
    Map<String, dynamic> query = {};
    //* Init token if private API
    if (this.isPrivate) {
      query = await setupAuthCode({});
    }

    this._url = Uri.https(this._baseUrl, this.endPoint, query);
    print(this._url);

    //* Do request to server
    final response = await http.put(this._url, headers: this._headers, body: body);

    //* Call response handler function
    return this._resposeHandler(response);
  }

  /*
   * Post Request Handler
  */
  Future<DefaultResp> upload({@required Map<String, dynamic> body, Map<String, dynamic> multipartFiles}) async {
    var query = {};
    //* Init token if private API
    if (this.isPrivate) {
      query = await setupAuthCode({});
    }

    this._url = Uri.https(this._baseUrl, this.endPoint, query);

    final request = new http.MultipartRequest("POST", this._url);

    //* Remove map with value == null
    body.removeWhere((key, value) => key == null || value == null);

    //* Add body to request fields
    request.fields.addAll(body.map((key, value) {
      return MapEntry(key, value?.toString());
    }));

    //* Add multipartFile to request files
    multipartFiles.forEach((key, value) async {
      request.files.add(await http.MultipartFile.fromPath(
        key,
        value.path,
      ));
    });

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    return this._resposeHandler(response);
  }

  /*
   * Response Handler Function
  */
  DefaultResp _resposeHandler(http.Response response) {
    try {
      //* Pretty print response
      final jsonDecoded = json.decode(response.body);
      final jsonEncoded = (new JsonEncoder.withIndent("   ")).convert(jsonDecoded);
      log('RESPONSE =>');
      log(jsonEncoded);

      return DefaultResp.fromJson(jsonDecoded);
    } catch (e) {
      // DefaultRes
      print(response.statusCode);
      print(e);
      // print(e.message);
      print(response.body);
      //* missing return
      return null;
    }
  }

  /*
   * Setup header with token from SharedPref Function
  */
  Future setupHeader() async {
    await SharedPrefHelper.shared.getToken().then((token) {
      this._headers = {'Authorization': 'Bearer $token'};

      //* Pretty print headers with token
      final headersEncoded = (new JsonEncoder.withIndent("   ")).convert(_headers);
      print(headersEncoded);
    });
  }

  /*
   * Setup auth code on query/ body
  */
  Future setupAuthCode(Map<String, dynamic> query) async {
    final token = await SharedPrefHelper.shared.getToken();
    final user = SharedPrefHelper.shared.user;

    if (this.isPrivate) {
      query['auth_code'] = token;
      query['user_id'] = user.id;
    }

    //* Pretty print headers with token
    final queryEncoded = (new JsonEncoder.withIndent("   ")).convert(query);
    log("QUERY =>");
    log(queryEncoded);

    return query;
  }
}
