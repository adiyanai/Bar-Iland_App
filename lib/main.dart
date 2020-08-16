import 'package:bar_iland_app/pages/important_links.dart';
import 'package:bar_iland_app/managers/lost_found_manager.dart';
import 'package:bar_iland_app/pages/add_lost.dart';
import 'package:bar_iland_app/pages/add_found.dart';
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
import './managers/buses_shuttles_manager.dart';
import './pages/shuttle_timetable.dart';

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
        // Default visual properties, like colors fonts and shapes, for this app's material widgets.
        theme: ThemeData(highlightColor: Colors.blue),
        //home: AuthPage(),
        // The application's top-level routing table.
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
          '/servicesByType': (BuildContext context) =>
              Services(model, "לפי סוג שירות"),
          '/servicesByArea': (BuildContext context) =>
              Services(model, "לפי מיקום"),
          '/בתי קפה ומסעדות': (BuildContext context) =>
              Services(model, "בתי קפה ומסעדות"),
          '/חנויות ועסקים': (BuildContext context) =>
              Services(model, "חנויות ועסקים"),
          '/מזכירויות ומנהלה': (BuildContext context) =>
              Services(model, "מזכירויות ומנהלה"),
          '/ספריות': (BuildContext context) => Services(model, "ספריות"),
          '/חדרי הנקה': (BuildContext context) => Services(model, "חדרי הנקה"),
          '/חדרי רווחה': (BuildContext context) =>
              Services(model, "חדרי רווחה"),
          '/פינות קפה': (BuildContext context) => Services(model, "פינות קפה"),
          '/מים חמים': (BuildContext context) => Services(model, "מים חמים"),
          '/מקררים': (BuildContext context) => Services(model, "מקררים"),
          '/מיקרוגלים': (BuildContext context) => Services(model, "מיקרוגלים"),
          '/מכונות חטיפים': (BuildContext context) =>
              Services(model, "מכונות חטיפים"),
          '/מכונות שתייה': (BuildContext context) =>
              Services(model, "מכונות שתייה"),
          '/מעבדות מחשבים': (BuildContext context) =>
              Services(model, "מעבדות מחשבים"),
          '/מניינים': (BuildContext context) => Services(model, "מניינים"),
          '/שערים ואבטחה': (BuildContext context) =>
              Services(model, "שערים ואבטחה"),
          '/מכשירי החייאה': (BuildContext context) =>
              Services(model, "מכשירי החייאה"),
          '/שירותי צילום והדפסה': (BuildContext context) =>
              Services(model, "שירותי צילום והדפסה"),
          '/קולרים': (BuildContext context) => Services(model, "קולרים"),
          '/lostFound': (BuildContext context) => LostFoundManager(model),
          '/addLost': (BuildContext context) => AddLost(model),
                    '/addFound': (BuildContext context) => AddFound(model),
          '/coursesInformation': (BuildContext context) => CoursesInformation(),
          '/busesShuttlesmanager': (BuildContext context) => BusesShuttlesManager(model),
          '/shuttleTimetable': (BuildContext context) => ShuttleTimetable()
        },
      ),
    );
  }
}
