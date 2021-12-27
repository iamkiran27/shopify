import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:my_shop/models/http_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _uid;
  DateTime _expiryDate;
  Timer timer;

  bool get isAuth {
    // print(auth != null);
    return auth != null;
  }

  String get uid {
    return _uid;
  }

  String get auth {
    if (_token != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      // print(_token);
      return _token;
    }
    return null;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url = "identitytoolkit.googleapis.com";
    try {
      final res = await http.post(
          Uri.https(url, "/v1/accounts:$urlSegment",
              {"key": "AIzaSyBTAW1OJlI5zoPNXe8QyrfCB0G0qMLlN0s"}),
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final resEx = json.decode(res.body);
      if (resEx['error'] != null) {
        throw HttpException(json.decode(res.body)['error']['message']);
      }
      if (urlSegment == "signInWithPassword") {
        print("Logged in for first time");
        _token = resEx['idToken'];
        _uid = resEx['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(resEx['expiresIn'])));
        print(_expiryDate.toIso8601String());
        autoLogout();

        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          "token": _token,
          "uid": _uid,
          "expiryDate": _expiryDate.toIso8601String()
        });
        prefs.setString("userData", userData);
        print("Stored data on device succesfully");
      }
    } catch (err) {
      print("Error :" + err.toString());
      throw err;
    }
  }

  Future<void> signUp(String email, String password, String urlSegment) async {
    return authenticate(email, password, urlSegment);
  }

  Future<void> signIn(String email, String password, String urlSegment) async {
    return authenticate(email, password, urlSegment);
  }

  void logout() async {
    print("Pressed logout");
    _token = null;
    _uid = null;
    _expiryDate = null;
    if (timer != null) {
      timer.cancel();
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      print("Doesn't contain any data on device");
      return false;
    }
    final userData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final userTime = DateTime.parse(userData["expiryDate"]);
    if (userTime.isBefore(DateTime.now())) {
      return false;
    }
    print("Entered auto login to check any preferences ! ");
    _token = userData["token"];
    _uid = userData["uid"];
    _expiryDate = userTime;
    print(_token);
    print("Time : $_expiryDate");
    autoLogout();
    notifyListeners();
    print("Auto logged in !!");
    return true;
  }

  void autoLogout() {
    final time = _expiryDate.difference(DateTime.now()).inSeconds;
    print("will Logout after :  $time");
    timer = Timer(Duration(seconds: time), logout);
  }
}
