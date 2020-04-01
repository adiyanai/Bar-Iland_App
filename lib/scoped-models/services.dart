import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/service.dart';
import '../models/user.dart';

class ConnectedServicesModel extends Model {
  List<String> buildingNumbers = [];
  List<Service> services = [];
  int _selServiceId;
  User _authenticatedUser;
  bool _isLoading = false;
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
    services = List.from(fetchedServiceList);
    _isLoading = false;
    notifyListeners();
    _selServiceId = null;
  }
}

void availabiltyReport() {

}

class UtilityModel extends ConnectedServicesModel {
  bool get isLoading {
    return _isLoading;
  }
}