import 'dart:convert';
//* unused import
// import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subditharda_apel/models/user_model.dart';

class SharedPrefHelper {
  static final shared = SharedPrefHelper();
  User user;

  Future setToken({@required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future setCurrentUser({@required String encodedUser}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', encodedUser);
  }

  Future removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('current_user');
  }

  Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('current_user') == null) {
      return null;
    }
    user = User.fromJson(json.decode(prefs.getString('current_user')));
    return user;
  }
}
