import 'package:flutter/material.dart';

// A model that represents a location at Bar Ilan University.
class BarIlanLocation {
  // The id of the location at the database.
  final String id;
  // The type of the location (such as building, gate, etc).
  final String type;
  // The name of the location (for example: Schleifer building or Geha gate).
  final String name;
  // The number of the location (for example: building 300 or gate 40).
  final String number;
  // The lon of the location.
  final double lon;
  // The lat of the location.
  final double lat;

  BarIlanLocation({
    @required this.id,
    @required this.type,
    @required this.name,
    @required this.number,
    @required this.lon,
    @required this.lat,
  });

  String get Id {
    return id;
  }

  String get Type {
    return type;
  }

  String get Name {
    return name;
  }

  String get Number {
    return number;
  }

  double get Lon {
    return lon;
  }

  double get Lat {
    return lat;
  }
}