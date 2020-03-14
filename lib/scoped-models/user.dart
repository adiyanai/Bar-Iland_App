import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserModel extends Model {
  User _authenticatedUser;
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  void login(String email, String password) {
    _authenticatedUser = User(id: 'kndbhjnc', email: email, password: password);
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBePDkpa3WV4UVazs9tRi0WnicXHsj2Ui0',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError =true;
    String message = 'Something went worng';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authenticaion succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'דוא"ל זה כבר קיים!';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}