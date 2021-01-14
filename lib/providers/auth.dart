import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app/models/http_exception.dart';
import 'package:todo_app/utils/app_constants.dart';
import 'package:todo_app/utils/unitily.dart';

/// This class is used to authenticate new and existing user
///
/// This class holds the information of logged in user. Also, This class contains the logic for autologin previous user
class Auth with ChangeNotifier {
  String _token;
  String _userId;

  /// This variable is to check if user is authenticated or not on app launch.
  /// This method checks the token value to authenticate.
  bool get isAuth {
    return token != null;
  }

  /// This variable holds the token value for logged in user
  String get token {
    return _token;
  }

  /// This variable holds the userId for logged in user
  String get userId {
    return _userId;
  }

  /// Authenticate new useer and existing user.
  ///
  /// Throws an [HttpException] or [Exception] if something goes
  /// wrong during authentication.
  Future<void> _authenticate(
    String email,
    String password,
    bool isSignUp,
  ) async {
    final isInternetConnected = await Util.checkInternet();
    if (!isInternetConnected) {
      throw Exception(INTERNET_NOT_CONNECTED);
    }
    final url = !isSignUp ? LOGIN_URL : SIGNUP_URL;
    try {
      final response = await http.post(
        url,
        body: !isSignUp
            ? json.encode(
                {EMAIL: email, PASSWORD: password},
              )
            : json.encode(
                {EMAIL: email, PASSWORD: password, NAME: TEMP_USER_NAME},
              ),
        headers: HEADERS,
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = responseData[TOKEN];
        HEADERS[AUTHORIZATION] = '${BEARER} ${_token}';
        _userId = responseData[USER][EMAIL];
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            TOKEN: _token,
            USER_ID: _userId,
          },
        );
        prefs.setString(USER_DATA, userData);
      } else {
        throw HttpException(ERROR_SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      throw e;
    }
  }

  /// Sign up new user.
  ///
  /// [email] and [password] required to sing up new user
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, true);
  }

  /// Sign in existing user.
  ///
  /// [email] and [password] required to sing in existing user
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, false);
  }

  /// This method tries to auto login with previous user details.
  ///
  /// Checks the user details in the shared prefrence and the based on token, suto log ins the user.
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(USER_DATA)) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString(USER_DATA)) as Map<String, Object>;
    _token = extractedUserData[TOKEN];
    _userId = extractedUserData[USER_ID];
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
