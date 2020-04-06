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

  Future<Null> fetchServices() async {
    _isLoading = true;
    notifyListeners();
    final http.Response response =
        await http.get('https://bar-iland-app.firebaseio.com/services.json');
    final List<Service> fetchedServiceList = [];
    Map<String, dynamic> buildingsServices = json.decode(response.body);
    buildingsServices.forEach((String buildingNumber, dynamic buildingData) {
      if (!buildingNumbers.contains(buildingNumber)) {
        buildingNumbers.add(buildingNumber);
      }
      buildingData.forEach((String type, dynamic servicesData) {
        if (type == "self-service-facilities") {
          servicesData.forEach((String id, dynamic serviceData) {
            Service service;
            if (serviceData['service-type'] == "מקרר") {
              service = RefrigeratorService(
                  milk: serviceData['milk'],
                  id: id,
                  serviceType: serviceData['service-type'],
                  buildingNumber: buildingNumber,
                  location: serviceData['location'],
                  availability: serviceData['availability']);
            } else {
              service = Service(
                  id: id,
                  serviceType: serviceData['service-type'],
                  buildingNumber: buildingNumber,
                  location: serviceData['location'],
                  availability: serviceData['availability']);
            }
            fetchedServiceList.add(service);
          });
        }
      });
    });
    services = fetchedServiceList;
    _isLoading = false;
    notifyListeners();
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
      'service-type': serviceType,
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

  Future<bool> availabiltyReport(
      String _selectedBuildingNumber, Service service) async {
    _isLoading = true;
    notifyListeners();
    int updatedAvailability;
    if (service.Availability == 0) {
      updatedAvailability = 1;
    } else {
      updatedAvailability = 0;
    }
    final Map<String, dynamic> updatedData = {
      'availability': updatedAvailability,
      'location': service.Location,
      'service-type': service.ServiceType,
    };

    final http.Response response = await http.put(
        'https://bar-iland-app.firebaseio.com/services/${_selectedBuildingNumber}/self-service-facilities/${service.Id}.json',
        body: json.encode(updatedData));
    final Map<String, dynamic> responseData = json.decode(response.body);
    final Service updatedService = Service(
        id: service.Id,
        buildingNumber: _selectedBuildingNumber,
        availability: updatedAvailability,
        location: responseData['location'],
        serviceType: responseData['service-type']);

    for (int i = 0; i < services.length; i++) {
      if (services[i].Id == service.Id) {
        services[i] = updatedService;
        break;
      }
    }
    notifyListeners();
    return true;
  }

  Future<bool> milkReport(
      String _selectedBuildingNumber, RefrigeratorService refrigerator) async {
    _isLoading = true;
    notifyListeners();
    int updatedMilkAvailability;
    if (refrigerator.Milk == 0) {
      updatedMilkAvailability = 1;
    } else {
      updatedMilkAvailability = 0;
    }
    final Map<String, dynamic> updatedData = {
      'availability': refrigerator.Availability,
      'location': refrigerator.Location,
      'service-type': refrigerator.ServiceType,
      'milk': updatedMilkAvailability
    };

    final http.Response response = await http.put(
        'https://bar-iland-app.firebaseio.com/services/${_selectedBuildingNumber}/self-service-facilities/${refrigerator.Id}.json',
        body: json.encode(updatedData));
    final Map<String, dynamic> responseData = json.decode(response.body);
    final RefrigeratorService updatedRefrigerator = RefrigeratorService(
        id: refrigerator.Id,
        buildingNumber: _selectedBuildingNumber,
        availability: responseData['availability'],
        location: responseData['location'],
        serviceType: responseData['service-type'],
        milk: updatedMilkAvailability);

    for (int i = 0; i < services.length; i++) {
      if (services[i].Id == refrigerator.Id) {
        services[i] = updatedRefrigerator;
        break;
      }
    }
    notifyListeners();
    return true;
  }
}

class UtilityModel extends ConnectedServicesModel {
  bool get isLoading {
    return _isLoading;
  }
}
