import 'package:bar_iland_app/pages/important_links.dart';
import 'package:bar_iland_app/pages/lost_found_manager.dart';
import 'package:bar_iland_app/pages/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import './scoped-models/main.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './pages/sign_up.dart';
import './pages/forget_password.dart';
import './services_manager.dart';
import './pages/events_calendar.dart';
import './pages/CampusMap.dart';
import './pages/important_links.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel model = MainModel();
  bool _isAuthenticated = false;
  @override
  void initState() {
    model.autoAuthenticate();
    model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : HomePage(),
          '/home': (BuildContext context) => HomePage(),
          '/signUp': (BuildContext context) => SignUp(),
          '/forgetPassword': (BuildContext context) => ForgetPassword(),
          '/serviceManager': (BuildContext context) => ServiceManager(model),
          '/eventsCalendar': (BuildContext context) => EventsCalendar(model),
          '/campusMap': (BuildContext context) => CampusMap(),
          '/importantLinks': (BuildContext context) => ImportantLinks(model),
          '/services': (BuildContext context) => Services(model, model.ServicesView),
          '/lostAndFound': (BuildContext context) => LostFoundManager(model),
        },
      ),
    );
  }
}
