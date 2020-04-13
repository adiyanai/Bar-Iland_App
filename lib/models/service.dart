import 'package:flutter/material.dart';

class Service {
  final String id;
  final String type;
  final String subtype;
  final String buildingNumber;
  final String location;

  Service(
      {@required this.id,
      @required this.type,
      @required this.subtype,
      @required this.buildingNumber,
      @required this.location});

  String get Id {
    return id;
  }

  String get Type {
    return type;
  }

  String get Subtype {
    return subtype;
  }

  String get BuildingNumber {
    return buildingNumber;
  }

  String get Location {
    return location;
  }
}

class MachineService extends Service {
  int availability;
  String availabilityReportDate;

  MachineService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String buildingNumber,
      @required String location,
      @required this.availability,
      @required this.availabilityReportDate})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            buildingNumber: buildingNumber,
            location: location);

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

class RefrigeratorService extends MachineService {
  int milk;
  String milkReportDate;
  String milkReportTime;
  RefrigeratorService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String buildingNumber,
      @required String location,
      @required int availability,
      @required String availabilityReportDate,
      @required this.milk,
      @required this.milkReportDate,
      @required this.milkReportTime})
      : super(
            id: id,
            type: type,
            subtype: subtype,
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

  String get MilkReportTime {
    return milkReportTime;
  }

  void set MilkReportTime(updatedReportTime) {
    milkReportTime = updatedReportTime;
  }
}

class WelfareRoomService extends Service {
  @required
  List<String> contains;
  WelfareRoomService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String buildingNumber,
      @required String location,
      @required this.contains})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            buildingNumber: buildingNumber,
            location: location);

  List<String> get Contains {
    return contains;
  }
}
