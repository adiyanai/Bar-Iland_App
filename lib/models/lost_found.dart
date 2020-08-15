import 'package:flutter/material.dart';

// A model that represents a lost item or a found item at Bar Ilan University. 
class LostFound {
  // The id of the lost item or the found item at the database.
  final String id;
  // Whether it is a lost item or a found item.
  final String type;
  // The type of the lost item or the found item (such as bag, clock, jewel, etc).
  final String subtype;
  // The name of the reporter.
  final String name;
  // The phone number of the reporter.
  final String phoneNumber;
  // The description of the lost item or the found item.
  final String description;
  // The reporting date.
  final String reportDate;
  // The URL of the image of the lost item or the found item at the cloud storage.
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
  // List of optional locations that the lost item may be in.
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
  // The general location (area) of the found item (for example: building 304).
  final String area;
  // The specific location of the found item (for example: floor 1, room 101).
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
