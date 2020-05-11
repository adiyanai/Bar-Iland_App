import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/connection.dart';
import '../scoped-models/main.dart';
import '../models/event.dart';
import './addEvent.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  Map<String, Icon> _eventTypesToIcons;
  AppBar _appBar;

  @override
  void initState() {
    super.initState();
    _connectionMode = widget._model.connectionMode;
    _calendarController = CalendarController();
    _selectedEvents = [];
    _eventTypesToIcons = _mapEventTypesToIcons();
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

  Map<String, Icon> _mapEventTypesToIcons() {
    Map<String, Icon> eventsToIcons = {
      "סטנדאפ": Icon(IconData(0xe24e, fontFamily: 'MaterialIcons')),
      "הרצאה/כנס": Icon(Icons.school),
      "ספורט": Icon(MdiIcons.basketball),
      "הפאב החברתי": Icon(FontAwesome5Solid.beer),
      "שבת בקמפוס": Icon(MaterialCommunityIcons.candle),
      "הופעה": Icon(MdiIcons.microphoneVariant),
      "TimeOut": Icon(MdiIcons.cookie),
      "מדרשה": Icon(MaterialCommunityIcons.book_open_page_variant),
      "הפססקר": Icon(MaterialCommunityIcons.file_document_edit_outline),
      "קפה ומאפה": Icon(MaterialCommunityIcons.coffee),
      "קבלת שבת": Icon(MaterialCommunityIcons.candle),
      "Live בקמפוס": Icon(MdiIcons.microphoneVariant),
      "אחר": Icon(MaterialCommunityIcons.dots_horizontal),
      "מסיבה": Icon(MdiIcons.balloon),
    };
    return eventsToIcons;
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
    double _screenWidth = MediaQuery.of(context).size.width;
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
            leading: _eventTypesToIcons[event.EventType],
            trailing: Icon(
              Icons.near_me,
              color: Colors.blue[700],
            ),
            title: Row(
              children: <Widget>[
                Text(
                  event.EventType,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple[700],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                event.EventDescription == ''
                    ? Container()
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.info,
                            size: 15,
                            color: Colors.black,
                          ),
                          SizedBox(width: 3),
                          Container(
                            width: _screenWidth * 0.6,
                            child: Text(
                              event.EventDescription,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 15,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 3),
                    Text(
                      event.Location,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 15,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 3),
                    Text(
                      event.Time,
                    ),
                  ],
                ),
              ],
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
            builder: (BuildContext context) => AddEvent(widget._model,
                _calendarController.selectedDay, _eventTypesToIcons)));
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
    //double _screenHeight = MediaQuery.of(context).size.height;
    //var padding = MediaQuery.of(context).padding;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _appBar = AppBar(
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
                  widget._model.isEventsLoading ||
                          widget._model.isAddEventLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildTableCalendar(),
                  SizedBox(
                    height: 15,
                  ),
                  // events look
                  Container(
                    height: 160,
                    child: ListView.builder(
                      itemCount: _selectedEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildEventLook(_selectedEvents[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // 'add-event' button
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: _connectionMode == ConnectionMode.RegisteredUser
              ? _registeredUserAddEvent
              : _guestUserAddEvent,
        ),
      ),
    );
  }
}
