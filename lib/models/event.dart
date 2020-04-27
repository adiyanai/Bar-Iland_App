import 'package:flutter/material.dart';

class Event {
  final String id;
  final DateTime date;
  final String time;
  final String location;
  final String eventType;
  final String eventDescription;

  Event(
      {@required this.id,
      @required this.date,
      @required this.time,
      @required this.location,
      @required this.eventType,
      @required this.eventDescription});

  DateTime get Date {
    return date;
  }

  String get Time {
    return time;
  }

  String get Location {
    return location;
  }

  String get EventType {
    return eventType;
  }

  String get EventDescription {
    return eventDescription;
  }
}
