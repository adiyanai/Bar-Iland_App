import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/connection.dart';
import '../scoped-models/main.dart';

class EventsCalendar extends StatefulWidget {
  final MainModel _model;
  EventsCalendar(this._model);

  @override
  State<StatefulWidget> createState() {
    return _EventsCalendarState();
  }
}

class _EventsCalendarState extends State<EventsCalendar> {
  CalendarController _calendarController;
  TextEditingController _eventController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  ConnectionMode _connectionMode;

  @override
  void initState() {
    super.initState();
    _connectionMode = widget._model.connectionMode;
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _selectedEvents = [];
    _events = {};
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  void _registeredUserAddEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('הוסף אירוע'),
            content: TextField(
              controller: _eventController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('שמור'),
                onPressed: () {
                  if (_eventController.text.isEmpty) return;
                  setState(() {
                    if (_events[_calendarController.selectedDay] != null) {
                      _events[_calendarController.selectedDay]
                          .add(_eventController.text);
                    } else {
                      _events[_calendarController.selectedDay] = [
                        _eventController.text
                      ];
                    }
                    _eventController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _guestUserAddEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('הוספת האירוע נכשלה'),
            content: Text('פעולה זו אפשרית עבור משתמשים רשומים בלבד'),
            actions: <Widget>[
              FlatButton(
                child: Text('אישור'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text(
              'לוח אירועים',
            ),
            SizedBox(
              width: 87,
            ),
            Image.asset(
              'assets/Bar_Iland_line.png',
              height: 35,
            ),
          ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                events: _events,
                calendarController: _calendarController,
                locale: 'he',
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarStyle: CalendarStyle(
                  weekendStyle: TextStyle(
                    color: Colors.black,
                  ),
                  outsideWeekendStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  todayColor: Colors.green,
                  selectedColor: Colors.blue,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  centerHeaderTitle: true,
                  titleTextStyle: TextStyle(fontSize: 20),
                ),
                weekendDays: [DateTime.friday, DateTime.saturday],
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onDaySelected: (DateTime date, List<dynamic> events) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
              ),
              ..._selectedEvents.map((event) => ListTile(
                    title: Text(event),
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _connectionMode == ConnectionMode.RegisteredUser ?  _registeredUserAddEvent : _guestUserAddEvent,
        ),
      ),
    );
  }
}
