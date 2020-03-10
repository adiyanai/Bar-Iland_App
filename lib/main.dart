import 'package:flutter/material.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './service_manager.dart';

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
