import 'package:flutter/material.dart';

class Station {
  final String id;
  final String number;
  final String name;
  final String closestGate;
  final String lat;
  final String lon;
  final List<String> buses;

  Station(
      {@required this.id,
      @required this.number,
      @required this.name,
      @required this.closestGate,
      @required this.lat,
      @required this.lon,
      @required this.buses});

  String get Id {
    return id;
  }

  String get Number {
    return number;
  }

  String get Name {
    return name;
  }

  String get ClosestGate {
    return closestGate;
  }

  String get Lat {
    return lat;
  }

  String get Lon {
    return lon;
  }

  List<String> get Buses {
    return buses;
  }
}
