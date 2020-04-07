import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

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
    try {
      var response = await http.post(url, body: bodyJson);
      var responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);
      _token = responseData['idToken'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userID = responseData['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
