import 'package:flutter/material.dart';

class ShuttleStation {
  final String id;
  final String number;
  final String lat;
  final String lon;

  ShuttleStation({
    @required this.id,
    @required this.number,
    @required this.lat,
    @required this.lon,
  });

  String get Id {
    return id;
  }

  String get Number {
    return number;
  }

  String get Lat {
    return lat;
  }

  String get Lon {
    return lon;
  }
}
