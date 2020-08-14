import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/connection.dart';
import '../scoped-models/main.dart';
import '../models/event.dart';
import '../models/event_location.dart';
import './add_event.dart';

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
  ScrollController _scrollController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  ConnectionMode _connectionMode;
  Map<String, Icon> _eventTypesToIcons;
  List<EventLocation> _eventLocations;
  Location _location;

  @override
  void initState() {
    _location = new Location();
    _connectionMode = widget._model.connectionMode;
    _calendarController = CalendarController();
    _scrollController =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: false);
    _selectedEvents = [];
    _eventTypesToIcons = _mapEventTypesToIcons();
    _events = {};
    // fetch all the necessery data
    initEvents();
    initEventsLocations();
    super.initState();
  }

  // fetch all the events data
  void initEvents() async {
    await widget._model.fetchEvents();
    setState(() {
      final List<Event> eventsData = widget._model.allEvents;
      _events = fromListToMapEvents(eventsData);
    });
  }

  // fetch the events locations  data if not fetched yet
  void initEventsLocations() async {
    if (widget._model.EventsLocations.isEmpty) {
      await widget._model.fetchEventsLocations();
    }
    setState(() {
      _eventLocations = widget._model.EventsLocations;
    });
  }

  // map every event type to an icon
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
      "אירוע כללי": Icon(Icons.calendar_today),
      "מסיבה": Icon(MdiIcons.balloon),
      "טקס": Icon(MdiIcons.microphoneVariant)
    };
    return eventsToIcons;
  }

  // convert the events data list to a map
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

  // build the background image
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

  // build the table calendar
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
      // on day selected save his events
      onDaySelected: (DateTime date, List<dynamic> events) {
        setState(() {
          // sort the events by their time
          events.sort((event1, event2) => (event1.Time).compareTo(event2.Time));
          _selectedEvents = events;
        });
      },
    );
  }

  // launch url
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // build the event look
  Column _buildEventLook(dynamic event, bool endList) {
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
            // just if the event.Location is not 'אחר' we can nevigate to this location
            trailing: event.Location != 'אחר'
                ? SizedBox(
                    width: 35,
                    child: IconButton(
                      icon: Icon(
                        Icons.near_me,
                        color: Colors.blue[700],
                      ),
                      onPressed: () async {
                        // get the data of the event location
                        EventLocation eventLocationData =
                            _eventLocations.firstWhere((EventLocation item) =>
                                (event.Location == item.NumberName));

                        LocationData userLocation =
                            await _location.getLocation();
                        String url =
                            'https://www.google.com/maps/dir/?api=1&origin=' +
                                userLocation.latitude.toString() +
                                ',' +
                                userLocation.longitude.toString() +
                                '&destination=' +
                                eventLocationData.Lat.toString() +
                                ',' +
                                eventLocationData.Lon.toString() +
                                '&travelmode=walking';
                        _launchURL(url);
                      },
                    ),
                  )
                : SizedBox(),
            title: Text(
              event.EventType,
              style: TextStyle(
                fontSize: 18,
                color: Colors.deepPurple[700],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                event.EventDescription == ''
                    ? Container()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.info,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 3),
                          Container(
                            width: _screenWidth * 0.5,
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
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(top: 3), child: Icon(
                      Icons.location_on,
                      size: 15,
                      color: Colors.black54,
                    ),),
                    SizedBox(width: 3),
                    Container(
                      width: _screenWidth * 0.5,
                      child: Text(
                        event.Location,
                      ),
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
        endList == true
            ? SizedBox(
                height: 30,
              )
            : Container(),
      ],
    );
  }

  // registered user - add event
  void _registeredUserAddEvent() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddEvent(widget._model,
                _calendarController.selectedDay, _eventTypesToIcons)));
  }

  // guest user - add event
  void _guestUserAddEvent() {
    // show alert dialog
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
          centerTitle: true,
          title: Text(
            'לוח אירועים',
          ),
        ),
        body: Stack(
          children: <Widget>[
            // build the background picture
            _buildBackgroundImage(),
            SingleChildScrollView(
              child: Column(
                children: [
                  // build the table calendar
                  widget._model.isEventsLoading ||
                          widget._model.isAddEventLoading ||
                          widget._model.isEventsLocationsLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildTableCalendar(),
                  SizedBox(
                    height: 15,
                  ),
                  // build events look
                  Container(
                    height: 160,
                    child: Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: _selectedEvents.length > 1 ? true : false,
                      child: ListView.builder(
                        padding: EdgeInsets.all(5),
                        controller: _scrollController,
                        itemCount: _selectedEvents.length,
                        addRepaintBoundaries: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _selectedEvents.length - 1) {
                            return _buildEventLook(
                                _selectedEvents[index], true);
                          } else {
                            return _buildEventLook(
                                _selectedEvents[index], false);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // build 'add-event' button
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
