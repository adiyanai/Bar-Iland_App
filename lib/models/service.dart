import 'package:flutter/material.dart';

class Service {
  final String serviceType;
  final String buildingNumber;
  final String location;
  final String availability;

  Service(
      {@required this.serviceType,
      @required this.buildingNumber,
      @required this.location,
      @required this.availability});

  String get ServiceType {
    return serviceType;
  }

  String get BuildingNumber {
    return buildingNumber;
  }

  String get Location {
    return location;
  }

  String get Availabilty {
    return availability;
  }
}
