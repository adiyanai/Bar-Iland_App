import 'package:flutter/material.dart';

class Location {
  final String id;
  final String type;
  final String name;
  final String number;

  Location({
    @required this.id,
    @required this.type,
    @required this.name,
    @required this.number,
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
}