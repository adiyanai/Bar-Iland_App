import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/service.dart';
import '../models/user.dart';

class ConnectedServicesModel extends Model {
  List<String> buildingNumbers = [];
  List<Service> services = [];
  bool _isLoading = false;
  //int _selServiceId;
  //User _authenticatedUser;
}

class ServicesModel extends ConnectedServicesModel {
  List<String> get BuildingNumbers {
    return List.from(buildingNumbers);
  }

  Future<Null> fetchServices() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://bar-iland-app.firebaseio.com/services.json')
        .then<Null>((http.Response response) {
      final List<Service> fetchedServiceList = [];
      Map<String, dynamic> buildingsServices = json.decode(response.body);
      buildingsServices.forEach((String buildingNumber, dynamic buildingData) {
        if (!buildingNumbers.contains(buildingNumber)) {
          buildingNumbers.add(buildingNumber);
        }
        buildingData.forEach((String type, dynamic servicesData) {
          Service service;
          servicesData.forEach((String id, dynamic serviceData) {
            if (type == "self-service-facilities") {
              if (serviceData['subtype'] == "מקרר") {
                service = RefrigeratorService(
                  id: id,
                  type: type,
                  subtype: serviceData['subtype'],
                  buildingNumber: buildingNumber,
                  location: serviceData['location'],
                  availability: serviceData['availability'],
                  availabilityReportDate:
                      serviceData['availability-report-date'],
                  milk: serviceData['milk'],
                  milkReportDate: serviceData['milk-report-date'],
                  milkReportTime: serviceData['milk-report-time'],
                );
              } else {
                service = MachineService(
                  id: id,
                  type: type,
                  subtype: serviceData['subtype'],
                  buildingNumber: buildingNumber,
                  location: serviceData['location'],
                  availability: serviceData['availability'],
                  availabilityReportDate:
                      serviceData['availability-report-date'],
                );
              }
              fetchedServiceList.add(service);
            } else if (type == "welfare-rooms") {
              List<String> contained = [];
              (serviceData['contains']).forEach((service) {
                contained.add(service);
              });
              service = WelfareRoomService(
                  id: id,
                  type: type,
                  subtype: serviceData['subtype'],
                  buildingNumber: buildingNumber,
                  location: serviceData['location'],
                  contains: contained);
              fetchedServiceList.add(service);
            }
          });
        });
      });
      fetchedServiceList.sort((service1, service2) {
        int result = service1.Location.compareTo(service2.Location);
        if (result != 0) {
          return result;
        } else {
          return service1.Subtype.compareTo(service2.Subtype);
        }
      });
      services = fetchedServiceList;
      _isLoading = false;
      notifyListeners();
    });
  }

  /*Future<bool> addService(
      {int availability = 1,
      String location = "קומה 1-, חדר רווחה",
      String serviceType = "מיקרוגל בשרי"}) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'availability': availability,
      'location': location,
      'subtype': serviceType,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/211/self-service-facilities.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    //final Map<String, dynamic> responseData = json.decode(response.body);

    _isLoading = false;
    notifyListeners();
    return true;
  }*/
  
  /*
  Future<bool> addService({
    String location = "חדר 320",
    String subtype = "חדר הנקה",
  }) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'location': location,
      'subtype': subtype,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/211/welfare-rooms.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    _isLoading = false;
    notifyListeners();
    return true;
  }
*/

Future<bool> addService({
    String location = "חדר 320",
    String subtype = "חדר הנקה",
  }) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> serviceData = {
      'location': location,
      'subtype': subtype,
    };

    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/services/211/welfare-rooms.json',
        body: json.encode(serviceData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> refrigeratorReport(
      String _selectedBuildingNumber,
      RefrigeratorService refrigerator,
      int updatedAvailability,
      int milkAvailability) {
    _isLoading = true;
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    String currentTime =
        "${today.hour.toString()}:${today.minute.toString().padLeft(2, '0')}";
    Map<String, dynamic> updatedData = {
      'subtype': refrigerator.Subtype,
      'location': refrigerator.Location,
      'availability': updatedAvailability,
      'availability-report-date': currentDate,
      'milk': milkAvailability,
      'milk-report-date': currentDate,
      'milk-report-time': currentTime
    };
    return http
        .put(
            'https://bar-iland-app.firebaseio.com/services/${_selectedBuildingNumber}/self-service-facilities/${refrigerator.Id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      refrigerator.Availability = updatedAvailability;
      refrigerator.AvailabilityReportDate =
          responseData['availability-report-date'];
      refrigerator.Milk = milkAvailability;
      refrigerator.MilkReportDate = responseData['milk-report-date'];
      refrigerator.MilkReportTime = responseData['milk-report-time'];
      for (int i = 0; i < services.length; i++) {
        if (services[i].Id == refrigerator.Id) {
          services[i] = refrigerator;
          notifyListeners();
          break;
        }
      }
      _isLoading = false;
      return true;
    });
  }

  Future<bool> availabiltyReport(String _selectedBuildingNumber,
      Service service, int updatedAvailability) {
    _isLoading = true;
    notifyListeners();
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    Map<String, dynamic> updatedData = {
      'availability': updatedAvailability,
      'subtype': service.Subtype,
      'location': service.Location,
      'availability-report-date': currentDate
    };
    return http
        .put(
            'https://bar-iland-app.firebaseio.com/services/${_selectedBuildingNumber}/self-service-facilities/${service.Id}.json',
            body: json.encode(updatedData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Service updatedService = MachineService(
          id: service.Id,
          type: "self-service-facilities",
          subtype: responseData['subtype'],
          buildingNumber: _selectedBuildingNumber,
          availability: updatedAvailability,
          location: responseData['location'],
          availabilityReportDate: currentDate);

      for (int i = 0; i < services.length; i++) {
        if (services[i].Id == service.Id) {
          services[i] = updatedService;
          notifyListeners();
          break;
        }
      }
      _isLoading = false;
      notifyListeners();
      return true;
    });
  }
}

class UtilityModel extends ConnectedServicesModel {
  bool get isLoading {
    return _isLoading;
  }
}
