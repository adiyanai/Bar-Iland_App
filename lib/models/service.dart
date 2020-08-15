import 'package:flutter/material.dart';

// A model that represents service at Bar Ilan University. 
class Service {
  // The id of the service at the database.
  final String id;
  // The type of the service (for example: Academic Service)
  final String type;
  // The subtype of the service (for example: library is a subtype of Academic Service)
  final String subtype;
  // The general location (area) of the service (for example: building 304).
  final String area;
  // Whether the service is inside the area or around it.
  final bool isInArea;
  // The specific location of the service (for example: floor 1, room 101).
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

// A model that represents a machine service at Bar Ilan University. 
class MachineService extends Service {
  // The availability of the machine - whether it is active or not.
  bool availability;
  // The date of the last report about the availability of the machine.
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

// A model that represents a refrigerator machine.
class RefrigeratorService extends MachineService {
  // Whether the refrigerator contains a milk or not.
  bool milk;
  // The date of the last report about the availability of the milk.
  String milkReportDate;
  // The time of the last report about the availability of the milk.
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

// A model that represents welfare service at Bar Ilan University. 
class WelfareService extends Service {
  @required
  // What does the welfare service contains.
  List<String> contains;
  WelfareService(
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

// A model that represents business at Bar Ilan University. 
class BusinessService extends Service {
  // The name of the business.
  String name = "";
  // The activity time of the business.
  String activityTime = "";
  // The phone number time of the business.
  String phoneNumber = "";
  // A general information about the business.
  String generalInfo = "";

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

// A model that represents academic service at Bar Ilan University. 
class AcademicService extends Service {
  // The name of the academic service.
  String name = "";
  // The activity time of the academic service.
  String activityTime = "";
  // The phone number of the academic service.
  String phoneNumber = "";
  // The mail of the academic service.
  String mail = "";
  // The website of the academic service.
  String website = "";

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

// A model that represents prayer service at Bar Ilan University. 
class PrayerService extends Service {
  // The schedule of Shacharit prayers in winter.
  String shacharitPrayersWinter;
  // The schedule of Mincha prayers in winter.
  String minchaPrayersWinter;
  // The schedule of Arvit prayers in winter.
  String arvitPrayersWinter;
  // The schedule of Shacharit prayers in summer.
  String shacharitPrayersSummer;
  // The schedule of Mincha prayers in summer.
  String minchaPrayersSummer;
  // The schedule of Arvit prayers in summer.
  String arvitPrayersSummer;
  PrayerService({
    @required String id,
    @required String type,
    @required String subtype,
    @required String area,
    @required bool isInArea,
    @required String specificLocation,
    @required this.shacharitPrayersWinter,
    @required this.minchaPrayersWinter,
    @required this.arvitPrayersWinter,
    @required this.shacharitPrayersSummer,
    @required this.minchaPrayersSummer,
    @required this.arvitPrayersSummer,
  }) : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  String get ShacharitPrayersWinter {
    return shacharitPrayersWinter;
  }

  String get MinchaPrayersWinter {
    return minchaPrayersWinter;
  }

  String get ArvitPrayersWinter {
    return arvitPrayersWinter;
  }

  String get ShacharitPrayersSummer {
    return shacharitPrayersSummer;
  }

  String get MinchaPrayersSummer {
    return minchaPrayersSummer;
  }

  String get ArvitPrayersSummer {
    return arvitPrayersSummer;
  }
}

// A model that represents computers lab service at Bar Ilan University. 
class ComputersLabService extends Service {
  // The activity time of the computers lab.
  String activityTime = "";
  // The phone number of the computers lab.
  String phoneNumber = "";
  // The mail of the computers lab.
  String mail = "";
  ComputersLabService(
      {@required String id,
      @required String type,
      @required String subtype,
      @required String area,
      @required bool isInArea,
      @required String specificLocation,
      @required this.activityTime,
      @required this.phoneNumber,
      @required this.mail})
      : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  String get ActivityTime {
    return activityTime;
  }

  String get PhoneNumber {
    return phoneNumber;
  }

  String get Mail {
    return mail;
  }
}

// A model that represents security service at Bar Ilan University. 
class SecurityService extends Service {
  // The activity time of the security service at weekdays.
  String weekdaysActivityTime = "";
  // The activity time of the security service at Fridays.
  String fridaysActivityTime = "";
  // The activity time of the security service at Saturdays.
  String saturdaysActivityTime = "";
  // The phone number of the security service.
  String phoneNumber = "";
  // The emergency phone numbe of the security service.
  String emergencyPhoneNumber = "";

  SecurityService({
    @required String id,
    @required String type,
    @required String subtype,
    @required String area,
    @required bool isInArea,
    @required String specificLocation,
    @required this.weekdaysActivityTime,
    @required this.fridaysActivityTime,
    @required this.saturdaysActivityTime,
    @required this.phoneNumber,
    @required this.emergencyPhoneNumber,
  }) : super(
            id: id,
            type: type,
            subtype: subtype,
            area: area,
            isInArea: isInArea,
            specificLocation: specificLocation);

  String get WeekdaysActivityTime {
    return weekdaysActivityTime;
  }

  String get FridaysActivityTime {
    return fridaysActivityTime;
  }

  String get SaturdaysActivityTime {
    return saturdaysActivityTime;
  }

  String get PhoneNumber {
    return phoneNumber;
  }

  String get EmergencyPhoneNumber {
    return emergencyPhoneNumber;
  }
}
