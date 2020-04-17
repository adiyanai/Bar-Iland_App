import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/service.dart';
import '../models/user.dart';

class ConnectedServicesModel extends Model {
  List<String> areas = [];
  List<Service> services = [];
  bool _isServicesLoading = false;
  //int _selServiceId;
  //User _authenticatedUser;
}

class ServicesModel extends ConnectedServicesModel {
  List<String> get Areas {
    return List.from(areas);
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
        if (int.tryParse(serviceType) == null) {
          Service service;
          servicesTypeData.forEach((String id, dynamic serviceData) {
            if (!areas.contains(serviceData['area'])) {
              areas.add(serviceData['area']);
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
              service = WelfareRoomService(
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
            }
          });
        }
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

  Future<bool> addAcademicService({
    String subtype = "ספריה",
    String name = "ספרית אגודת הסטודנטים",
    String activityTime = "ימים א'-ה': 10:00 עד 14:00",
    String phoneNumber = "03-5343666",
    String mail = "pniyot@bis.org.il",
    String website = "http://www.bis.org.il/",
    String area = "בניין 107",
    bool isInArea = true,
    String specificLocation = "קומה 1",
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

  Future<bool> refrigeratorReport(
      String _selectedArea,
      RefrigeratorService refrigerator,
      bool updatedAvailability,
      bool milkAvailability) {
    _isServicesLoading = true;
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    String currentTime =
        "${today.hour.toString()}:${today.minute.toString().padLeft(2, '0')}";
    Map<String, dynamic> updatedData = {
      'subtype': refrigerator.Subtype,
      'area': _selectedArea,
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

  Future<bool> availabiltyReport(String _selectedArea,
      Service service, bool updatedAvailability) {
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
          area: _selectedArea,
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
}

class UtilityModel extends ConnectedServicesModel {
  bool get isServicesLoading {
    return _isServicesLoading;
  }
}
