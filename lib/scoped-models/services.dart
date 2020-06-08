import 'dart:convert';
import 'dart:async';

import 'package:bar_iland_app/models/bar_ilan_location.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/service.dart';

class ConnectedServicesModel extends Model {
  List<BarIlanLocation> allServicesLocations = [];
  List<String> servicesAreas = [];
  List<Service> services = [];
  bool _isServicesLoading = false;
  int _selectedServiceIndex = 0;
  Location _currentLocation = new Location();
  LocationData userLocation;
}

class ServicesModel extends ConnectedServicesModel {

  List<String> get ServicesAreas {
    return List.from(servicesAreas);
  }

  List<BarIlanLocation> get AllServicesLocations {
    return allServicesLocations;
  }

  int get SelectedServiceIndex {
    return _selectedServiceIndex;
  }

  void set SelectedServiceIndex(selectedServiceIndex) {
    _selectedServiceIndex = selectedServiceIndex;
  }

  void getCurrentLocation() async {
    _isServicesLoading = true;
    notifyListeners();
    try {
      userLocation = await _currentLocation.getLocation();
    } catch (e) {
    }
    _isServicesLoading = false;
    notifyListeners();
  }

  Future<Null> fetchServicesLocations() {
    _isServicesLoading = true;
    notifyListeners();
    return http
        .get('https://bar-iland-app.firebaseio.com/locations.json')
        .then<Null>((http.Response response) {
      final List<BarIlanLocation> fetchedLocations = [];
      Map<String, dynamic> locationsTypeData = json.decode(response.body);
      locationsTypeData
          .forEach((String locationType, dynamic locationsTypeData) {
        if (locationType != "squares") {
          BarIlanLocation location;
          locationsTypeData.forEach((String id, dynamic locationData) {
            location = BarIlanLocation(
              id: id,
              type: locationType,
              name: locationData['name'],
              number: locationData['number'],
              lon: locationData['lon'],
              lat: locationData['lat'],
            );
            fetchedLocations.add(location);
          });
        }
      });
      fetchedLocations.sort((location1, location2) {
        List<String> location1SplitNumber = location1.Number.split(" ");
        List<String> location2SplitNumber = location2.Number.split(" ");
        if (location1SplitNumber[0] != "שער" &&
            location2SplitNumber[0] != "שער") {
          return int.parse(location1SplitNumber[1])
              .compareTo(int.parse(location2SplitNumber[1]));
        } else {
          int result =
              location1SplitNumber[0].compareTo(location2SplitNumber[0]);
          if (result != 0) {
            return result;
          } else {
            return int.parse(location1SplitNumber[1])
                .compareTo(int.parse(location2SplitNumber[1]));
          }
        }
      });
      allServicesLocations = fetchedLocations;
      _isServicesLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchServices() {
    _isServicesLoading = true;
    notifyListeners();
    return http
        .get('https://bar-iland-app.firebaseio.com/services.json')
        .then<Null>((http.Response response) {
      final List<Service> fetchedServiceList = [];
      Map<String, dynamic> servicesData = json.decode(response.body);
      servicesData.forEach((String serviceType, dynamic servicesTypeData) {
        Service service;
        servicesTypeData.forEach((String id, dynamic serviceData) {
          if (!servicesAreas.contains(serviceData['area'])) {
            servicesAreas.add(serviceData['area']);
          }
          if (serviceType == "machines") {
            if (serviceData['subtype'] == "מקרר") {
              service = RefrigeratorService(
                id: id,
                type: serviceType,
                subtype: serviceData['subtype'],
                area: serviceData['area'],
                isInArea: serviceData['isInArea'],
                specificLocation: serviceData['specificLocation'],
                availability: serviceData['availability'],
                availabilityReportDate: serviceData['availabilityReportDate'],
                milk: serviceData['milk'],
                milkReportDate: serviceData['milkReportDate'],
                milkReportTime: serviceData['milkReportTime'],
              );
            } else {
              service = MachineService(
                id: id,
                type: serviceType,
                subtype: serviceData['subtype'],
                area: serviceData['area'],
                isInArea: serviceData['isInArea'],
                specificLocation: serviceData['specificLocation'],
                availability: serviceData['availability'],
                availabilityReportDate: serviceData['availabilityReportDate'],
              );
            }
            fetchedServiceList.add(service);
          } else if (serviceType == "welfare") {
            List<String> contained = [];
            (serviceData['contains']).forEach((service) {
              contained.add(service);
            });
            service = WelfareService(
                id: id,
                type: serviceType,
                subtype: serviceData['subtype'],
                area: serviceData['area'],
                isInArea: serviceData['isInArea'],
                specificLocation: serviceData['specificLocation'],
                contains: contained);
            fetchedServiceList.add(service);
          } else if (serviceType == "businesses") {
            service = BusinessService(
                id: id,
                type: serviceType,
                subtype: serviceData['subtype'],
                area: serviceData['area'],
                isInArea: serviceData['isInArea'],
                specificLocation: serviceData['specificLocation'],
                name: serviceData['name'],
                phoneNumber: serviceData['phoneNumber'],
                activityTime: serviceData['activityTime'],
                generalInfo: serviceData['generalInfo']);
            fetchedServiceList.add(service);
          } else if (serviceType == "academicServices") {
            service = AcademicService(
              id: id,
              type: serviceType,
              subtype: serviceData['subtype'],
              area: serviceData['area'],
              isInArea: serviceData['isInArea'],
              specificLocation: serviceData['specificLocation'],
              name: serviceData['name'],
              phoneNumber: serviceData['phoneNumber'],
              activityTime: serviceData['activityTime'],
              mail: serviceData['mail'],
              website: serviceData['website'],
            );
            fetchedServiceList.add(service);
          } else if (serviceType == "prayerServices") {
            service = PrayerService(
              id: id,
              type: serviceType,
              subtype: serviceData['subtype'],
              area: serviceData['area'],
              isInArea: serviceData['isInArea'],
              specificLocation: serviceData['specificLocation'],
              shacharitPrayersWinter: serviceData['shacharitPrayersWinter'],
              minchaPrayersWinter: serviceData['minchaPrayersWinter'],
              arvitPrayersWinter: serviceData['arvitPrayersWinter'],
              shacharitPrayersSummer: serviceData['shacharitPrayersSummer'],
              minchaPrayersSummer: serviceData['minchaPrayersSummer'],
              arvitPrayersSummer: serviceData['arvitPrayersSummer'],
            );
            fetchedServiceList.add(service);
          } else if (serviceType == "computersLabs") {
            service = ComputersLabService(
              id: id,
              type: serviceType,
              subtype: serviceData['subtype'],
              area: serviceData['area'],
              isInArea: serviceData['isInArea'],
              specificLocation: serviceData['specificLocation'],
              activityTime: serviceData['activityTime'],
              phoneNumber: serviceData['phoneNumber'],
              mail: serviceData['mail'],
            );
            fetchedServiceList.add(service);
          } else if (serviceType == "securityServices") {
            service = SecurityService(
              id: id,
              type: serviceType,
              subtype: serviceData['subtype'],
              area: serviceData['area'],
              isInArea: serviceData['isInArea'],
              specificLocation: serviceData['specificLocation'],
              weekdaysActivityTime: serviceData['weekdaysActivityTime'],
              fridaysActivityTime: serviceData['fridaysActivityTime'],
              saturdaysActivityTime: serviceData['saturdaysActivityTime'],
              phoneNumber: serviceData['phoneNumber'],
              emergencyPhoneNumber: serviceData['emergencyPhoneNumber'],
            );
            fetchedServiceList.add(service);
          }
        });
      });

      fetchedServiceList.sort((service1, service2) {
        int result =
            service1.SpecificLocation.compareTo(service2.SpecificLocation);
        if (result != 0) {
          return result;
        } else {
          return service1.Subtype.compareTo(service2.Subtype);
        }
      });
      services = fetchedServiceList;
      _isServicesLoading = false;
      notifyListeners();
    });
  }

  Future<bool> addMachineService({
    String subtype = "קולר",
    String area = "בניין 504",
    bool isInArea = true,
    String specificLocation = "קומה -1",
    bool availability = true,
    //bool milk = true,
  }) async {
    _isServicesLoading = true;
    notifyListeners();
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";

    //String currentTime =
    "${today.hour.toString()}:${today.minute.toString().padLeft(2, '0')}";

    final Map<String, dynamic> serviceData = {
      'subtype': subtype,
      'area': area,
      'isInArea': isInArea,
      'specificLocation': specificLocation,
      'availability': availability,
      'availabilityReportDate': currentDate,
      //'milk': milk,
      //'milkReportDate': currentDate,
      //'milkReportTime': currentTime
    };
    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/machines.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isServicesLoading = false;
      notifyListeners();
      return false;
    }
    _isServicesLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> addBusinessService({
    String subtype = "ציוד משרדי וכלי כתיבה",
    String name = "האקדמון",
    String activityTime = "ימים א'-ה': 17:00-08:00, יום ו': 12:00-08:00",
    String phoneNumber = "08-9147788",
    String generalInfo = "",
    String area = "בניין 107",
    bool isInArea = true,
    String specificLocation = "",
  }) async {
    _isServicesLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'subtype': subtype,
      'name': name,
      'activityTime': activityTime,
      'phoneNumber': phoneNumber,
      'area': area,
      'isInArea': isInArea,
      'specificLocation': specificLocation,
      'generalInfo': generalInfo,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/businesses.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isServicesLoading = false;
      notifyListeners();
      return false;
    }
    _isServicesLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> addAcademicService({
    String subtype = "מזכירות",
    String name = "שירותי סטודנט",
    String activityTime = "א',ג': 14:00-11:30, ב', ה': 10:30-8:30",
    String phoneNumber = "03-5318652",
    String mail = "Students.Services@mail.biu.ac.il",
    String website = "",
    String area = "בניין 509",
    bool isInArea = true,
    String specificLocation = "",
  }) async {
    _isServicesLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'subtype': subtype,
      'name': name,
      'activityTime': activityTime,
      'phoneNumber': phoneNumber,
      'mail': mail,
      'website': website,
      'area': area,
      'isInArea': isInArea,
      'specificLocation': specificLocation,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/academicServices.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isServicesLoading = false;
      notifyListeners();
      return false;
    }
    _isServicesLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> addPrayerService({
    String subtype = "מניין",
    String area = "בניין 506",
    bool isInArea = true,
    String specificLocation = "מעונות גרוז",
    String shacharitPrayersWinter = "",
    String minchaPrayersWinter = "",
    String arvitPrayersWinter = "22:00\n",
    String shacharitPrayersSummer = "",
    String minchaPrayersSummer = "",
    String arvitPrayersSummer = "22:00\n",
  }) async {
    _isServicesLoading = true;

    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'subtype': subtype,
      'area': area,
      'isInArea': isInArea,
      'specificLocation': specificLocation,
      'shacharitPrayersWinter': shacharitPrayersWinter,
      'minchaPrayersWinter': minchaPrayersWinter,
      'arvitPrayersWinter': arvitPrayersWinter,
      'shacharitPrayersSummer': shacharitPrayersSummer,
      'minchaPrayersSummer': minchaPrayersSummer,
      'arvitPrayersSummer': arvitPrayersSummer,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/prayerServices.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isServicesLoading = false;
      notifyListeners();
      return false;
    }
    _isServicesLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> addComputerLabsService({
    String subtype = "מעבדת מחשבים",
    String activityTime = "ימים א'-ה', 08:30 עד 16:00",
    String phoneNumber = "03-5317895",
    String mail = "",
    String area = "בניין 404",
    bool isInArea = true,
    String specificLocation = "קומה שנייה וקומה שלישית",
  }) async {
    _isServicesLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'subtype': subtype,
      'activityTime': activityTime,
      'phoneNumber': phoneNumber,
      'mail': mail,
      'area': area,
      'isInArea': isInArea,
      'specificLocation': specificLocation,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/computersLabs.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isServicesLoading = false;
      notifyListeners();
      return false;
    }
    _isServicesLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> refrigeratorReport(RefrigeratorService refrigerator,
      bool updatedAvailability, bool milkAvailability) {
    _isServicesLoading = true;
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    String currentTime =
        "${today.hour.toString()}:${today.minute.toString().padLeft(2, '0')}";
    Map<String, dynamic> updatedData = {
      'subtype': refrigerator.Subtype,
      'area': refrigerator.Area,
      'isInArea': refrigerator.IsInArea,
      'specificLocation': refrigerator.SpecificLocation,
      'availability': updatedAvailability,
      'availabilityReportDate': currentDate,
      'milk': milkAvailability,
      'milkReportDate': currentDate,
      'milkReportTime': currentTime
    };
    return http
        .put(
            'https://bar-iland-app.firebaseio.com/services/machines/${refrigerator.Id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      refrigerator.Availability = updatedAvailability;
      refrigerator.AvailabilityReportDate =
          responseData['availabilityReportDate'];
      refrigerator.Milk = milkAvailability;
      refrigerator.MilkReportDate = responseData['milkReportDate'];
      refrigerator.MilkReportTime = responseData['milkReportTime'];
      for (int i = 0; i < services.length; i++) {
        if (services[i].Id == refrigerator.Id) {
          services[i] = refrigerator;
          notifyListeners();
          break;
        }
      }
      _isServicesLoading = false;
      return true;
    });
  }

  Future<bool> availabiltyReport(Service service, bool updatedAvailability) {
    _isServicesLoading = true;
    notifyListeners();
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    Map<String, dynamic> updatedData = {
      'area': service.Area,
      'isInArea': service.IsInArea,
      'specificLocation': service.SpecificLocation,
      'subtype': service.Subtype,
      'availability': updatedAvailability,
      'availabilityReportDate': currentDate
    };
    return http
        .put(
            'https://bar-iland-app.firebaseio.com/services/machines/${service.Id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Service updatedService = MachineService(
          id: service.Id,
          type: "machines",
          subtype: responseData['subtype'],
          area: responseData['area'],
          isInArea: responseData['isInArea'],
          specificLocation: responseData['specificLocation'],
          availability: updatedAvailability,
          availabilityReportDate: currentDate);

      for (int i = 0; i < services.length; i++) {
        if (services[i].Id == service.Id) {
          services[i] = updatedService;
          notifyListeners();
          break;
        }
      }
      _isServicesLoading = false;
      notifyListeners();
      return true;
    });
  }

  Future<bool> addSecurityService({
    String subtype = "שירותי אבטחה",
    String weekdaysActivityTime = "06:30 עד 18:00",
    String fridaysActivityTime = "06:30 עד 12:00",
    String saturdaysActivityTime = "סגור",
    String area = "שער 40",
    bool isInArea = true,
    String specificLocation = "",
    String phoneNumber = "03-5317171",
    String emergencyPhoneNumber = "03-5317777",
  }) async {
    _isServicesLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'subtype': subtype,
      'weekdaysActivityTime': weekdaysActivityTime,
      'fridaysActivityTime': fridaysActivityTime,
      'saturdaysActivityTime': saturdaysActivityTime,
      'area': area,
      'isInArea': isInArea,
      'specificLocation': specificLocation,
      'phoneNumber': phoneNumber,
      'emergencyPhoneNumber': emergencyPhoneNumber
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/securityServices.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isServicesLoading = false;
      notifyListeners();
      return false;
    }
    _isServicesLoading = false;
    notifyListeners();
    return true;
  }
}

class UtilityModel extends ConnectedServicesModel {
  bool get isServicesLoading {
    return _isServicesLoading;
  }
}
