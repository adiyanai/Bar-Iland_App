import 'package:flutter/material.dart';

class Service {
  final String id;
  final String serviceType;
  final String buildingNumber;
  final String location;
  int availability;

  Service(
      {@required this.id,
      @required this.serviceType,
      @required this.buildingNumber,
      @required this.location,
      @required this.availability});

  String get Id {
    return id;
  }

  String get ServiceType {
    return serviceType;
  }

  String get BuildingNumber {
    return buildingNumber;
  }

  String get Location {
    return location;
  }

  int get Availability {
    return availability;
  }

  void set Availability(int updatedAvailability) {
    availability = updatedAvailability;
  }
}

class RefrigeratorService extends Service {
  final int milk;
  RefrigeratorService(
      {@required String id,
      @required String serviceType,
      @required String buildingNumber,
      @required String location,
      @required int availability,
      @required this.milk})
      : super(
            id: id,
            serviceType: serviceType,
            buildingNumber: buildingNumber,
            location: location,
            availability: availability);

  int get Milk {
    return milk;
  }
}
