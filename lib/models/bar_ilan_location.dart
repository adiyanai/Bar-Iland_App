import 'package:flutter/material.dart';

class BarIlanLocation {
  final String id;
  final String type;
  final String name;
  final String number;
  final double lon;
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