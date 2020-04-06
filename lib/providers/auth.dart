import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userID;

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
    var response = await http.post(url, body: bodyJson);
    var responseData = json.decode(response.body);
    _token = responseData['idToken'];
    _expireDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseData['expiresIn'])));
    _userID = responseData['localId'];
    notifyListeners();
  }
}
