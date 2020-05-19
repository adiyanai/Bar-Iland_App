import 'package:flutter/material.dart';

class EventLocation {
  final String id;
  final String type;
  final String numberName;
  final double lat;
  final double lon;

  EventLocation({
    @required this.id,
    @required this.type,
    @required this.numberName,
    @required this.lat,
    @required this.lon
  });

  String get Id {
    return id;
  }

  String get Type {
    return type;
  }

  String get NumberName {
    return numberName;
  }

  double get Lat {
    return this.lat;
  }

  double get Lon {
    return this.lon;
  }
}