import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/connection.dart';

class UserModel extends Model {
  final API_KEY = '';
  User _authenticatedUser;
  bool _isUserLoading = false;
  Timer _authTimer;
  ConnectionMode _connectionMode = ConnectionMode.GuestUser;
  PublishSubject<bool> _userSubject = PublishSubject();

  ConnectionMode get connectionMode {
    return _connectionMode;
  }

  void set connectionMode(ConnectionMode cM) {
    _connectionMode = cM;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  bool get isUserLoading {
    return _isUserLoading;
  }

  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isUserLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${API_KEY}',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${API_KEY}',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'נא הזן את הפרטים בשנית';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authenticaion succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userPassword', password);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'דוא"ל לא קיים';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'סיסמה לא תקינה';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'דוא"ל זה כבר קיים!';
    }
    _isUserLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      // if the time has expired authenticate again
      if (parsedExpiryTime.isBefore(now)) {
        final String userEmail = prefs.getString('userEmail');
        final String userPassword = prefs.getString('userPassword');
        final Map<String, dynamic> successInformation =
            await authenticate(userEmail, userPassword, AuthMode.Login);
        if (!successInformation['success']) {
          _authenticatedUser = null;
          notifyListeners();
        } else {
          _connectionMode = ConnectionMode.RegisteredUser;
        }
        return;
      }
      _connectionMode = ConnectionMode.RegisteredUser;
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userPassword');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    // if the time has expired autoAuthenticate again
    _authTimer = Timer(Duration(seconds: time), autoAuthenticate);
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    _isUserLoading = true;
    notifyListeners();
    final Map<String, dynamic> resetData = {
      'requestType': 'PASSWORD_RESET',
      'email': email,
    };
    http.Response response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=${API_KEY}',
      body: json.encode(resetData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'Something went worng';
    if (responseData.containsKey('email')) {
      hasError = false;
      message = 'Reset password succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'דוא"ל לא קיים';
    }
    _isUserLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}
