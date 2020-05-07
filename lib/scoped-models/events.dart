import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event.dart';

class EventsModel extends Model {
  final databaseURL = 'https://bar-iland-app.firebaseio.com/events';
  List<Event> _events = [];
  List<String> _eventTypeList = [];
  List<String> _eventsLocations = [];
  bool _isEventsLoading = false;
  String _selEventId;

  List<Event> get allEvents {
    return List.from(_events);
  }

  bool get isEventsLoading {
    return _isEventsLoading;
  }

  int get selectedEventIndex {
    return _events.indexWhere((Event event) {
      return event.id == _selEventId;
    });
  }

  String get selectedEventId {
    return _selEventId;
  }

  Event get selectedEvent {
    if (selectedEventId == null) {
      return null;
    }

    return _events.firstWhere((Event event) {
      return event.id == _selEventId;
    });
  }

  List<String> get EventTypeList {
    if (_eventTypeList.isEmpty) {
      fetchEventTypeList();
    }
    return _eventTypeList;
  }

  List<String> get EventsLocations {
    if (_eventsLocations.isEmpty) {
      fetchEventsLocations();
    }
    return _eventsLocations;
  }

  Future<bool> addEvent(DateTime date, String time, String location,
      String eventType, String eventDescription) async {
    _isEventsLoading = true;
    notifyListeners();
    final Map<String, dynamic> eventData = {
      'date': date.toString(),
      'time': time,
      'location': location,
      'eventType': eventType,
      'eventDescription': eventDescription
    };

    try {
      final http.Response response = await http
          .post(databaseURL + '/eventsData.json', body: json.encode(eventData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isEventsLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final Event newEvent = Event(
          id: responseData['name'],
          date: date,
          time: time,
          location: location,
          eventType: eventType,
          eventDescription: eventDescription);
      _events.add(newEvent);
      _selEventId = responseData['name'];
      _isEventsLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isEventsLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent() {
    _isEventsLoading = true;
    final deletedEventId = selectedEvent.id;
    _events.removeAt(selectedEventIndex);
    _selEventId = null;
    notifyListeners();
    return http
        .delete(databaseURL + '/eventsData.json' + '/${deletedEventId}.json')
        .then((http.Response response) {
      _isEventsLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isEventsLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchEvents() {
    _isEventsLoading = true;
    notifyListeners();
    return http
        .get(databaseURL + '/eventsData.json')
        .then<Null>((http.Response response) {
      final List<Event> fetchedEventsList = [];
      final Map<String, dynamic> eventsData = json.decode(response.body);
      if (eventsData == null) {
        _isEventsLoading = false;
        notifyListeners();
        return;
      }
      eventsData.forEach((String eventId, dynamic eventData) {
        final Event event = Event(
            id: eventId,
            date: DateTime.parse(eventData['date']),
            time: eventData['time'],
            location: eventData['location'],
            eventType: eventData['eventType'],
            eventDescription: eventData['eventDescription']);
        fetchedEventsList.add(event);
      });
      _events = fetchedEventsList;
      _isEventsLoading = false;
      notifyListeners();
      _selEventId = null;
    }).catchError((error) {
      _isEventsLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchEventTypeList() {
    _isEventsLoading = true;
    notifyListeners();
    return http
        .get(databaseURL + '/eventTypes.json')
        .then<Null>((http.Response response) {
      final Map<String, dynamic> eventTypesData = json.decode(response.body);
      if (eventTypesData == null) {
        _isEventsLoading = false;
        notifyListeners();
        return;
      }
      eventTypesData.forEach((String eventTypeId, dynamic eventTypeData) {
        _eventTypeList.add(eventTypeData['eventType']);
      });
      _isEventsLoading = false;
      notifyListeners();
      //_selEventId = null;
    }).catchError((error) {
      _isEventsLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchEventsLocations() {
    _isEventsLoading = true;
    String locationsURL = 'https://bar-iland-app.firebaseio.com/locations.json';
    notifyListeners();
    return http.get(locationsURL).then<Null>((http.Response response) {
      final Map<String, dynamic> locationsData = json.decode(response.body);
      String location;
      locationsData.forEach((String locationType, dynamic locationTypeData) {
        if (locationType == 'amphitheaters') {
          locationTypeData.forEach((String id, dynamic locationData) {
            location = locationData['number'] + ' - ' + locationData['name'];
            _eventsLocations.add(location);
          });
        } else if (locationType == 'buildings') {
          locationTypeData.forEach((String id, dynamic locationData) {
            if (locationData['name'] != 'מעונות') {
              location = locationData['number'] + ' - ' + locationData['name'];
              _eventsLocations.add(location);
            }
          });
        } else if (locationType == 'squares') {
          locationTypeData.forEach((String id, dynamic locationData) {
            _eventsLocations.add(locationData['name']);
          });
        } else if (locationType == 'structures') {
          locationTypeData.forEach((String id, dynamic locationData) {
            if (locationData['name'] != 'בנק מזרחי-טפחות') {
              location = locationData['number'] + ' - ' + locationData['name'];
              _eventsLocations.add(location);
            }
          });
        }
      });
      _eventsLocations.add('אחר');
      _isEventsLoading = false;
      notifyListeners();
      //_selEventId = null;
    }).catchError((error) {
      _isEventsLoading = false;
      notifyListeners();
      return;
    });
  }
}
