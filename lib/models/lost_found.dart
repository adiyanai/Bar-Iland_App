import 'package:flutter/material.dart';

class LostFound {
  final String id;
  final String type;
  final String subtype;
  final String description;
  final String area;
  final bool isInArea;
  final String specificLocation;
  final String phoneNumber;
  final String picture;

  LostFound(
      {@required this.id,
      @required this.type,
      @required this.subtype,
      @required this.description,
      @required this.area,
      @required this.isInArea,
      @required this.specificLocation,
      @required this.phoneNumber,
      @required this.picture});

  String get Id {
    return id;
  }

  String get Type {
    return type;
  }

  String get Subtype {
    return subtype;
  }

   String get Description {
    return description;
  }

  String get Area {
    return area;
  }

  bool get IsInArea {
    return isInArea;
  }

  String get SpecificLocation {
    return specificLocation;
  }

   String get PhoneNumber {
    return phoneNumber;
  }

   String get Picture {
    return picture;
  }
}
