import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/service.dart';
import '../models/user.dart';

class ConnectedServicesModel extends Model {
  List<String> _buildingNumbers = [];
  List<Service> _services = [];
  int _selServiceId;
  User _authenticatedUser;
  bool _isLoading = false;
}

class ServicesModel extends ConnectedServicesModel {
  List<Service> get Services {
    return List.from(_services);
  }

   List<String> get BuildingNumbers {
    return List.from(_buildingNumbers);
  }

  /*
  int get selectedServiceId {
    return _selServiceId;
  }

  Service get selectedService {
    if (selectedServiceId == null) {
      return null;
    }
    return _services[selectedServiceId];
  }
  */

  Future<List<Service>> fetchServices() async {
    _isLoading = true;
    notifyListeners();
    final http.Response response =
        await http.get('https://bar-iland-app.firebaseio.com/services.json');
    final List<Service> fetchedServiceList = [];
    Map<String, dynamic> buildingsServices = json.decode(response.body);

    /*    
  if (buildingsServices == null) {
    _isLoading = false;
    notifyListeners();
  }
  */
  
    buildingsServices.forEach((String buildingNumber, dynamic buildingData) {
      if (!_buildingNumbers.contains(buildingNumber)) {
        _buildingNumbers.add(buildingNumber);
      }
      buildingData.forEach((String type, dynamic servicesData) {
        if (type == "self-service-facilities") {
          servicesData.forEach((dynamic serviceData) {
            Service service = Service(
                serviceType: serviceData['service-type'],
                buildingNumber: buildingNumber,
                location: serviceData['location'],
                availability: serviceData['availability']);
            fetchedServiceList.add(service);
          });
        } else if (type == "business-services") {
          servicesData.forEach((dynamic serviceData) {
            Service service = Service(
                serviceType: serviceData['service-type'],
                buildingNumber: buildingNumber,
                location: serviceData['location'],
                availability: serviceData['availability']);
            fetchedServiceList.add(service);
          });
        }
      });
    });
    _services = List.from(fetchedServiceList);
    _isLoading = false;
    notifyListeners();
    _selServiceId = null;
    return fetchedServiceList;
  }
}

/*
class UtilityModel extends ConnectedServicesModel {
  bool get isLoading {
    return _isLoading;
  }
}
*/
