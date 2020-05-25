import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event.dart';
import '../models/event_location.dart';
import './main.dart';

class EventsModel extends Model {
  final databaseURL = 'https://bar-iland-app.firebaseio.com/events';
  List<Event> _events = [];
  List<String> _eventTypes = [];
  List<EventLocation> _eventsLocations = [];
  bool _isEventsLoading = false;
  bool _isEventTypeLoading = false;
  bool _isEventsLocationsLoading = false;
  bool _isAddEventLoading = false;
  String _selEventId;

  List<Event> get allEvents {
    return List.from(_events);
  }

  bool get isEventsLoading {
    return _isEventsLoading;
  }

  bool get isEventTypeLoading {
    return _isEventTypeLoading;
  }

  bool get isEventsLocationsLoading {
    return _isEventsLocationsLoading;
  }

  bool get isAddEventLoading {
    return _isAddEventLoading;
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

  List<String> get EventTypes {
    return _eventTypes;
  }

  List<EventLocation> get EventsLocations {
    return _eventsLocations;
  }

  Future<bool> addEvent(DateTime date, String time, String location,
      String eventType, String eventDescription, MainModel model) async {
    _isAddEventLoading = true;
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
          .post(databaseURL + '/eventsData.json' + '?auth=${model.user.Token}', body: json.encode(eventData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isAddEventLoading = false;
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
      _isAddEventLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isAddEventLoading = false;
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

  Future<Null> fetchEventTypes() {
    _isEventTypeLoading = true;
    notifyListeners();
    return http
        .get(databaseURL + '/eventTypes.json')
        .then<Null>((http.Response response) {
      final List<String> fetchedEventTypeList = [];
      final Map<String, dynamic> eventTypesData = json.decode(response.body);
      if (eventTypesData == null) {
        _isEventTypeLoading = false;
        notifyListeners();
        return;
      }
      eventTypesData.forEach((String eventTypeId, dynamic eventTypeData) {
        fetchedEventTypeList.add(eventTypeData['eventType']);
      });
      _eventTypes = fetchedEventTypeList;
      _eventTypes.add('אחר');
      _isEventTypeLoading = false;
      notifyListeners();
      //_selEventId = null;
    }).catchError((error) {
      _isEventTypeLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchEventsLocations() {
    _isEventsLocationsLoading = true;
    String locationsURL = 'https://bar-iland-app.firebaseio.com/locations.json';
    notifyListeners();
    return http.get(locationsURL).then<Null>((http.Response response) {
      final List<EventLocation> fetchedEventsLocations = [];
      final Map<String, dynamic> locationsData = json.decode(response.body);
      String location, locationId;
      double lat, lon;
      locationsData.forEach((String locationType, dynamic locationTypeData) {
        locationTypeData.forEach((String id, dynamic locationData) {
          if ((locationData['name'] != 'מעונות') &&
              (locationData['name'] != 'בנק מזרחי-טפחות')) {
            locationId = id;
            location = locationData['number'] + ' - ' + locationData['name'];
            lat = locationData['lat'];
            lon = locationData['lon'];
            final EventLocation newEventLocation = EventLocation(
              id: locationId,
              type: locationType,
              numberName: location,
              lat: lat,
              lon: lon,
            );
            fetchedEventsLocations.add(newEventLocation);
          }
        });
      });
      _eventsLocations = fetchedEventsLocations;
      _isEventsLocationsLoading = false;
      notifyListeners();
      //_selEventId = null;
    }).catchError((error) {
      _isEventsLocationsLoading = false;
      notifyListeners();
      return;
    });
  }
}
