import 'package:flutter/material.dart';

class Service {
  final String id;
  final String type;
  final String subtype;
  final String area;
  final bool isInArea;
  final String specificLocation;

  Service(
      {@required this.id,
      @required this.type,
      @required this.subtype,
      @required this.area,
      @required this.isInArea,
      @required this.specificLocation});

  String get Id {
    return id;
  }

  String get Type {
    return type;
  }

  String get Subtype {
    return subtype;
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
}

class MachineService extends Service {
  bool availability;
  String availabilityReportDate;

  MachineService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String area,
      @required bool isInArea,
      @required String specificLocation,
      @required this.availability,
      @required this.availabilityReportDate})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  bool get Availability {
    return availability;
  }

  void set Availability(bool updatedAvailability) {
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
  bool milk;
  String milkReportDate;
  String milkReportTime;
  RefrigeratorService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String area,
      @required bool isInArea,
      @required String specificLocation,
      @required bool availability,
      @required String availabilityReportDate,
      @required this.milk,
      @required this.milkReportDate,
      @required this.milkReportTime})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation,
            availability: availability,
            availabilityReportDate: availabilityReportDate);

  bool get Milk {
    return milk;
  }

  void set Milk(bool updatedMilk) {
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
      @required String area,
      @required bool isInArea,
      @required String specificLocation,
      @required this.contains})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  List<String> get Contains {
    return contains;
  }
}

class BusinessService extends Service {
  String name = "–––";
  String activityTime = "–––";
  String phoneNumber = "–––";
  String generalInfo = "–––";

  BusinessService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String area,
      @required bool isInArea,
      @required String specificLocation,
      @required this.name,
      this.activityTime,
      this.phoneNumber,
      this.generalInfo})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  String get Name {
    return name;
  }

  String get ActivityTime {
    return activityTime;
  }

  String get PhoneNumber {
    return phoneNumber;
  }

  String get GeneralInfo {
    return generalInfo;
  }
}

class AcademicService extends Service {
  String name = "–––";
  String activityTime = "–––";
  String phoneNumber = "–––";
  String mail = "–––";
  String website = "–––";

  AcademicService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String area,
      @required bool isInArea,
      @required String specificLocation,
      @required this.name,
      this.activityTime,
      this.phoneNumber,
      this.mail,
      this.website})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  String get Name {
    return name;
  }

  String get ActivityTime {
    return activityTime;
  }

  String get PhoneNumber {
    return phoneNumber;
  }

  String get Mail {
    return mail;
  }

  String get Website {
    return website;
  }
}
