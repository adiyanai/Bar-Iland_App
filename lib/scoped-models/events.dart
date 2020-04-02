import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event.dart';

class EventsModel extends Model {
  final databaseURL = 'https://bar-iland-app.firebaseio.com/events.json';
  List<Event> _events = [];
  bool _isLoading = false;
  String _selEventId;

  List<Event> get allEvents {
    return List.from(_events);
  }

  bool get isLoading {
    return _isLoading;
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

  Future<bool> addEvent(
      DateTime date, String eventType, String eventDescription) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> eventData = {
      'date': date,
      'eventType': eventType,
      'eventDescription': eventDescription
    };

    try {
      final http.Response response =
          await http.post(databaseURL, body: json.encode(eventData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      //final Map<String, dynamic> responseData = json.decode(response.body);
      final Event newEvent = Event(
          date: date, eventType: eventType, eventDescription: eventDescription);
      _events.add(newEvent);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent() {
    _isLoading = true;
    final deletedEventId = selectedEvent.id;
    _events.removeAt(selectedEventIndex);
    _selEventId = null;
    notifyListeners();
    return http
        .delete(databaseURL + '/${deletedEventId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchEvents() {
    _isLoading = true;
    notifyListeners();
  }
}
