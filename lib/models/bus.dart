import 'package:flutter/material.dart';

class Bus {
  final String id;
  final String number;
  final String origin;
  final String destination;
  final String moovitUrl;
  final List<String> citiesBetween;

  Bus(
      {@required this.id,
      @required this.number,
      @required this.origin,
      @required this.destination,
      @required this.moovitUrl,
      @required this.citiesBetween});

  String get Id {
    return id;
  }

  String get Number {
    return number;
  }

  String get Origin {
    return origin;
  }

  String get Destination {
    return destination;
  }

  String get MoovitUrl {
    return moovitUrl;
  }

  List<String> get CitiesBetween {
    return citiesBetween;
  }
}
