import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './pages/sign_up.dart';
import './pages/forget_password.dart';
import './service_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => !_isAuthenticated ? AuthPage() : HomePage(),
          '/signUp': (BuildContext context) => SignUp(),
          '/forgetPassword': (BuildContext context) => ForgetPassword(),
          '/service_manager': (BuildContext context) => !_isAuthenticated ? AuthPage() : ServiceManager(),
        },
      ),
    );
  }
}