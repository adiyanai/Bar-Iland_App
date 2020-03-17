import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './pages/sign_up.dart';
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
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage(),
          '/signUp': (BuildContext context) => SignUp(),
          '/service_manager': (BuildContext context) => ServiceManager(_model),
        },
      ),
    );
  }
}
