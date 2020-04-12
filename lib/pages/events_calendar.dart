import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/connection.dart';
import '../scoped-models/main.dart';
import '../models/event.dart';

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
    initEvents();
  }

  void initEvents() async {
    await widget._model.fetchEvents();
    setState(() {
      final List<Event> eventsData = widget._model.allEvents;
      if (!eventsData.isEmpty) {
        eventsData.forEach((Event event) {
          if (_events.containsKey(event.date)) {
            _events[event.date].add(event);
          } else {
            _events[event.date] = [];
            _events[event.date].add(event);
          }
        });
      }
    });
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
                    widget._model.addEvent(_calendarController.selectedDay,
                        'סוג אירוע', _eventController.text);
                    final Event newEvent = Event(
                        id: widget._model.selectedEventId,
                        date: _calendarController.selectedDay,
                        eventType: 'סוג אירוע',
                        eventDescription: _eventController.text);
                    if (_events[_calendarController.selectedDay] != null) {
                      _events[_calendarController.selectedDay].add(newEvent);
                    } else {
                      _events[_calendarController.selectedDay] = [
                        newEvent
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
                    title: Text(event.EventDescription),
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _connectionMode == ConnectionMode.RegisteredUser
              ? _registeredUserAddEvent
              : _guestUserAddEvent,
        ),
      ),
    );
  }
}
