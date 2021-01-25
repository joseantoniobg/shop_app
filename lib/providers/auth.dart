import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../config/general_config.dart';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { Signup, Login }

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null && _token != null) {
      if (_expiryDate.isAfter(DateTime.now())) {
        return _token;
      }
    }
    return null;
  }

  Future<void> logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extratedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    if (DateTime.parse(extratedUserData['expiryDate'])
        .isBefore(DateTime.now())) {
      return false;
    }

    _token = extratedUserData['token'];
    _userId = extratedUserData['userId'];
    _expiryDate = DateTime.parse(extratedUserData['expiryDate']);

    return true;
  }

  Future<void> signUpOrSignIn(
      String email, String password, AuthMode authMode) async {
    try {
      final response = await http.post(
        authMode == AuthMode.Signup
            ? GeneralConfig.authSignUpURL
            : GeneralConfig.authLogInURL,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      }
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } on HttpException catch (error) {
      var errorDescription = '';
      switch (error.toString()) {
        case 'EMAIL_EXISTS':
          {
            errorDescription =
                'This e-mail is already resgistred, you can provide another one or sign in';
          }

          break;
        case 'OPERATION_NOT_ALLOWED':
          {
            errorDescription =
                'You cannot log in with a email right now, try again later';
          }
          break;
        case 'OPERATION_NOT_ALLOWED':
          {
            errorDescription =
                'You cannot log in with a email right now, try again later';
          }
          break;
        case 'TOO_MANY_ATTEMPTS_TRY_LATER':
          {
            errorDescription =
                'We detected an anormal activity in this account, please try again later';
          }
          break;
        case 'EMAIL_NOT_FOUND':
          {
            errorDescription = 'E-mail or password are incorrect';
          }
          break;
        case 'INVALID_EMAIL':
          {
            errorDescription = 'E-mail or password are incorrect';
          }
          break;
        case 'INVALID_PASSWORD':
          {
            errorDescription = 'E-mail or password are incorrect';
          }
          break;
        case 'WEAK_PASSWORD':
          {
            errorDescription = 'Password too weak, please try another one';
          }
          break;
        case 'USER_DISABLED':
          {
            errorDescription = 'You cannot sign in due to account banishment';
          }
          break;
        default:
          {
            errorDescription = 'An error occured, please try again later';
          }
      }
      throw errorDescription;
    } catch (error) {
      var errorDescription =
          'Could not authenticate you right now... Try again later!';
      throw errorDescription;
    }
  }
}
