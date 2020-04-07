import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userID;
  Timer _autoLogoutTimer;

  String get token {
    return _token;
  }

  String get userID {
    return _userID;
  }

  bool isAuth() {
    if (_token == null) {
      return false;
    }
    if (_expireDate.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expireDate = null;
    _userID = null;
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
    }
    await workWithMemory('Delete');
    notifyListeners();
  }

  void autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
    }
    var timerSec = _expireDate.difference(DateTime.now()).inSeconds;
    print(timerSec);
    _autoLogoutTimer = Timer(
      Duration(seconds: timerSec),
      logout,
    );
  }

  Future<void> workWithMemory(String whatToDo) async {
    Future<SharedPreferences> _prefs =
        SharedPreferences.getInstance().catchError((onError) {
      print(onError.toString());
    });
    final SharedPreferences prefs = await _prefs;
    if (whatToDo == 'Save') {
      print('Save');
      prefs.setString('userData', null);
      prefs.setString(
        'userData',
        json.encode(
          {
            'token': _token,
            'userId': _userID,
            'expireDate': _expireDate.toIso8601String(),
          },
        ),
      );
    }
    if (whatToDo == 'Delete') {
      print('Delete');
      prefs.setString('userData', null);
    }
    if (whatToDo == 'Get') {
      print('Get');
      if (prefs.getString('userData') == null) return;
      var userData = json.decode(prefs.getString('userData'));
      _token = userData['token'];
      _userID = userData['userId'];
      _expireDate = DateTime.parse(userData['expireDate']);
      autoLogout();
      notifyListeners();
    }
  }

  Future<void> authorization(
      String email, String password, String typeOfAuth) async {
    String url = 'https://identitytoolkit.googleapis.com/v1/accounts:' +
        typeOfAuth +
        '?key=AIzaSyDACBX09wzZmQTh7S9aDMz8GYToIaMbXnY';
    String bodyJson = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    try {
      var response = await http.post(url, body: bodyJson);
      var responseData = json.decode(response.body);
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);
      _token = responseData['idToken'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userID = responseData['localId'];
      await workWithMemory('Save');
      autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
