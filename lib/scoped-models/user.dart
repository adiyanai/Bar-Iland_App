import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/auth.dart';

class UserModel extends Model {
  User _authenticatedUser;
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBePDkpa3WV4UVazs9tRi0WnicXHsj2Ui0',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBePDkpa3WV4UVazs9tRi0WnicXHsj2Ui0',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went worng';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authenticaion succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'דוא"ל לא קיים';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'סיסמה לא תקינה';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'דוא"ל זה כבר קיים!';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}
