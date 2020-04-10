import 'package:flutter/material.dart';

class Service {
  final String id;
  final String serviceType;
  final String buildingNumber;
  final String location;
  int availability;
  String availabilityReportDate;

  Service(
      {@required this.id,
      @required this.serviceType,
      @required this.buildingNumber,
      @required this.location,
      @required this.availability,
      @required this.availabilityReportDate});

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

  String get AvailabilityReportDate {
    return availabilityReportDate;
  }

    void set AvailabilityReportDate(updatedReportDate) {
    availabilityReportDate = updatedReportDate;
  }
}

class RefrigeratorService extends Service {
  int milk;
  String milkReportDate;
  RefrigeratorService(
      {@required String id,
      @required String serviceType,
      @required String buildingNumber,
      @required String location,
      @required int availability,
      @required String availabilityReportDate,
      @required this.milk, @required this.milkReportDate})
      : super(
            id: id,
            serviceType: serviceType,
            buildingNumber: buildingNumber,
            location: location,
            availability: availability,
            availabilityReportDate: availabilityReportDate);

  int get Milk {
    return milk;
  }
  
  void set Milk(int updatedMilk) {
    milk = updatedMilk;
  }

  String get MilkReportDate {
    return milkReportDate;
  }

    void set MilkReportDate(updatedReportDate) {
    milkReportDate = updatedReportDate;
  }
}
