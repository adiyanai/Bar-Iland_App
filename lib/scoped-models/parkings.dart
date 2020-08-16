import 'dart:convert';

import 'package:bar_iland_app/models/parking.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class ParkignsModel extends Model {
  // List of all the parkings on Bar Ilan University and around it.
  List<Parking> _parkings = [];
    // Whether the data of the parkings is loading from or to the database.
  bool isParkingsLoading = false;

  List<Parking> get Parkings {
     return List.from(_parkings);
  }

  // Fetch the parkings from the database.
  Future<Null> fetchParkings() {
    isParkingsLoading = true;
    notifyListeners();
    return http.get('https://bar-iland-app.firebaseio.com/parkings.json').then<Null>((http.Response response) {
      final List<Parking> fetchedParkings = [];
      final Map<String, dynamic> parkingsData = json.decode(response.body);
      parkingsData.forEach((String parkingId, dynamic parkingData) {
        Parking parking = Parking(
            id: parkingId,
            name: parkingData['name'],
            location: parkingData['location'],
            closestGate: parkingData['closestGate'],
            price: parkingData['price'],
            lat: parkingData['lat'],
            lon: parkingData['lon'],
            );
        fetchedParkings.add(parking);
      });
      _parkings = fetchedParkings;
      isParkingsLoading = false;
      notifyListeners();
    }).catchError((error) {
      isParkingsLoading = false;
      notifyListeners();
      return;
    });
  }

  // Add a parking to the database.
    Future<bool> addParking({
    String name,
    String location,
    String closestGate,
    String price,
    String lat,
    String lon,
  }) async {
    isParkingsLoading = true;
    notifyListeners();
    final Map<String, dynamic> parkingData = {
      'name': name,
      'location': location,
      'closestGate': closestGate,
      'price': price,
      'lat': lat,
      'lon': lon,
    };
    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/parkings.json',
        body: json.encode(parkingData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      isParkingsLoading = false;
      notifyListeners();
      return false;
    }
    isParkingsLoading = false;
    notifyListeners();
    return true;
  } 
}