import 'package:bar_iland_app/pages/add_lost.dart';
import 'package:bar_iland_app/pages/important_links.dart';
import 'package:bar_iland_app/managers/lost_found_manager.dart';
import 'package:bar_iland_app/pages/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import './scoped-models/main.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './pages/sign_up.dart';
import './pages/forget_password.dart';
import './managers/services_manager.dart';
import './pages/events_calendar.dart';
import './pages/campus_map.dart';
import './pages/important_links.dart';
import './pages/courses_information.dart';


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
        theme: ThemeData(highlightColor: Colors.blue),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : HomePage(model),
          '/home': (BuildContext context) => HomePage(model),
          '/signUp': (BuildContext context) => SignUp(),
          '/forgetPassword': (BuildContext context) => ForgetPassword(),
          '/serviceManager': (BuildContext context) => ServiceManager(model),
          '/eventsCalendar': (BuildContext context) => EventsCalendar(model),
          '/campusMap': (BuildContext context) => CampusMap(),
          '/importantLinks': (BuildContext context) => ImportantLinks(model),
          '/services': (BuildContext context) => Services(model, model.ServicesView),
          '/lostFound': (BuildContext context) => LostFoundManager(model),
          '/addLost':  (BuildContext context) => AddLost(model),
          '/coursesInformation': (BuildContext context) => CoursesInformation()
        },
      ),
    );
  }
}
