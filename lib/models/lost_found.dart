import 'package:flutter/material.dart';

class LostFound {
  final String id;
  final String type;
  final String subtype;
  final String description;
  final String phoneNumber;
  final String picture;

  LostFound(
      {@required this.id,
      @required this.type,
      @required this.subtype,
      @required this.description,
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

  String get PhoneNumber {
    return phoneNumber;
  }

  String get Picture {
    return picture;
  }
}


class Lost extends LostFound {
  List<String> optionalLocations = []; 
  Lost({
    @required id,
    @required type,
    @required subtype,
    @required description,
    @required phoneNumber,
    @required picture,
    @required this.optionalLocations,
  });

  List<String> get OptionalLocations {
    return optionalLocations;
  }
}

class Found extends LostFound {
  final String area;
  final bool isInArea;
  final String specificLocation;

  Found({
    @required id,
    @required type,
    @required subtype,
    @required description,
    @required phoneNumber,
    @required picture,
    @required this.area,
    @required this.isInArea,
    @required this.specificLocation,
  });

  String get Area {
    return area;
  }

  bool get IsInArea {
    return isInArea;
  }

  String get SpecificLocation {
    return specificLocation;
  }
}