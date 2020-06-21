import 'package:flutter/material.dart';

class Parking {
  final String id;
  final String name;
  final String location;
  final String closestGate;
  final String price;
  final String lat;
  final String lon;
  Parking({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.closestGate,
    @required this.price,
    @required this.lat,
    @required this.lon,
  });

  String get Id {
    return id;
  }

  String get Name {
    return name;
  }

  String get Location {
    return location;
  }

  String get ClosestGate {
    return closestGate;
  }

  String get Price {
    return price;
  }

  String get Lat {
    return lat;
  }

  String get Lon {
    return lon;
  }
}
