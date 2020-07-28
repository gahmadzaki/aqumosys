import 'package:aquamonitoring/fcm.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _currentEmail = '';
  String get currentEmail => _currentEmail;

  String _currentToken = '';
  String get currentToken => _currentToken;

  getInitialUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentEmail = (prefs.getString('currentEmail') ?? '');
    _currentToken = (prefs.getString('currentToken') ?? getToken() ?? '');
    print('get initial user');
    notifyListeners();
  }

  setUser(newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentEmail = newEmail;
    await prefs.setString('currentEmail', newEmail);
    print(_currentEmail);
    notifyListeners();
  }

  setToken(newToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentToken = newToken;
    await prefs.setString('currentToken', newToken);
    print(_currentToken);
    notifyListeners();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentEmail = '';
    await prefs.setString('currentEmail', '');
    notifyListeners();
  }
}
