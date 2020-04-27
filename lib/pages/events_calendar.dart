import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/connection.dart';
import '../scoped-models/main.dart';
import '../models/event.dart';
import './addEvent.dart';

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
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  ConnectionMode _connectionMode;

  @override
  void initState() {
    super.initState();
    _connectionMode = widget._model.connectionMode;
    _calendarController = CalendarController();
    _selectedEvents = [];
    _events = {};
    initEvents();
  }

  void initEvents() async {
    await widget._model.fetchEvents();
    setState(() {
      final List<Event> eventsData = widget._model.allEvents;
      _events = fromListToMapEvents(eventsData);
    });
  }

  Map<DateTime, List<dynamic>> fromListToMapEvents(List<Event> eventsData) {
    Map<DateTime, List<dynamic>> eventsMap = {};
    if (!eventsData.isEmpty) {
      eventsData.forEach((Event event) {
        if (eventsMap.containsKey(event.date)) {
          eventsMap[event.date].add(event);
        } else {
          eventsMap[event.date] = [];
          eventsMap[event.date].add(event);
        }
      });
    }
    return eventsMap;
  }

  Map<String, String> _mapToEventType() {
    Map<String, String> moreInfoToEventType = {
      'קפה ומאפה': '---',
      'הופעה': 'אומנ/ים:',
      'שבת בקמפוס': '---',
      'קבלת שבת': 'אוכל/כיבוד:',
      'ספורט': 'ענף ספורט:',
      'אחר': '---',
      'הפאב החברתי': '---',
      'הרצאה': 'מרצה:',
      'הפססקר': '---',
      'מדרשה': '---',
      'מסיבה': '---',
      'סטנדאפ': 'אומנ/ים:',
      'TimeOut': 'אוכל/כיבוד:',
      'בקמפוס Live': 'אומנ/ים:'
    };
    return moreInfoToEventType;
  }

  Container _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/people_party.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }

  TableCalendar _buildTableCalendar() {
    return TableCalendar(
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
        weekdayStyle: TextStyle(
          color: Colors.black54,
        ),
      ),
      onDaySelected: (DateTime date, List<dynamic> events) {
        setState(() {
          // sort the events by their time
          events.sort((event1, event2) => (event1.Time).compareTo(event2.Time));
          _selectedEvents = events;
        });
      },
    );
  }

  Column _buildEventLook(dynamic event) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white38,
            border: Border.all(
              color: Colors.black26,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.music_note,
            ),
            title: Text(
              event.Time,
            ),
            subtitle: Text(
              event.EventType,
            ),
          ),
        ),
      ],
    );
  }

  void _registeredUserAddEvent() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddEvent(widget._model, _calendarController.selectedDay)));
  }

  void _guestUserAddEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('הוספת אירוע'),
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'לוח אירועים',
              ),
              Image.asset(
                'assets/Bar_Iland_line.png',
                height: 35,
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            // background picture
            _buildBackgroundImage(),
            SingleChildScrollView(
              child: Column(
                children: [
                  // calendar
                  widget._model.isEventsLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildTableCalendar(),
                  SizedBox(
                    height: 15,
                  ),
                  // events look
                  ..._selectedEvents.map(
                    (event) => _buildEventLook(event),
                  ),
                ],
              ),
            ),
          ],
        ),
        // 'add-event' button
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
