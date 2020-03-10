import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './pages/sign_up.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage(),
          '/signUp': (BuildContext context) => SignUp(),
        },
      ),
    return MaterialApp(
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/home': (BuildContext context) => HomePage(),
        '/service_manager': (BuildContext context) => ServiceManager(),
      },
    );
  }
}
