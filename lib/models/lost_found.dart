import 'package:flutter/material.dart';

class LostFound {
  final String id;
  final String type;
  final String subtype;
  final String name;
  final String phoneNumber;
  final String description;
  final String reportDate;
  final String imageUrl;

  LostFound(
      {@required this.id,
      @required this.type,
      @required this.subtype,
      @required this.name,
      @required this.phoneNumber,
      @required this.description,
      @required this.reportDate,
      @required this.imageUrl});

  String get Id {
    return id;
  }

  String get Type {
    return type;
  }

  String get Subtype {
    return subtype;
  }

  String get Name {
    return name;
  }

  String get PhoneNumber {
    return phoneNumber;
  }

  String get Description {
    return description;
  }

  String get ReportDate {
    return reportDate;
  }

  String get ImageUrl {
    return imageUrl;
  }
}

class Lost extends LostFound {
  List<String> optionalLocations = [];
  Lost({
    @required id,
    @required type,
    @required subtype,
    @required name,
    @required phoneNumber,
    @required description,
    @required reportDate,
    @required imageUrl,
    @required this.optionalLocations,
  }) : super(
          id: id,
          type: type,
          subtype: subtype,
          name: name,
          phoneNumber: phoneNumber,
          description: description,
          reportDate: reportDate,
          imageUrl: imageUrl,
        );

  List<String> get OptionalLocations {
    return optionalLocations;
  }
}

class Found extends LostFound {
  final String area;
  final String specificLocation;

  Found({
    @required id,
    @required type,
    @required subtype,
    @required name,
    @required phoneNumber,
    @required description,
    @required reportDate,
    @required imageUrl,
    @required this.area,
    @required this.specificLocation,
  }) : super(
          id: id,
          type: type,
          subtype: subtype,
          name: name,
          phoneNumber: phoneNumber,
          description: description,
          reportDate: reportDate,
          imageUrl: imageUrl,
        );

  String get Area {
    return area;
  }

  String get SpecificLocation {
    return specificLocation;
  }
}
