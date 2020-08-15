import 'package:flutter/material.dart';

// A model that represents parking at Bar Ilan University or around it. 
class Parking {
  // The id of the parking at the database.
  final String id;
  // The name of the parking, (for example: Wohl parking).
  final String name;
  // The location of the parking, (for example: Wohl parking).
  final String location;
  // The closest gate to the parking.
  final String closestGate;
  // The price of the parking.
  final String price;
  // The lon of the location.
  final String lon;
  // The lat of the location.
  final String lat;
  
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
