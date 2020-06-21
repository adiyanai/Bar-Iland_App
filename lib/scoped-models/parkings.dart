import 'dart:convert';

import 'package:bar_iland_app/models/parking.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class ParkignsModel extends Model {
  List<Parking> _parkings = [];
  bool isParkingsLoading = false;

  List<Parking> get Parkings {
     return List.from(_parkings);
  }

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

    Future<bool> addParking({
    String name = "חניון כלכלה - על בסיס שעתי",
    String location = "",
    String closestGate = "",
    String price = "מחיר כניסה חד פעמי: 15.5 שקלים. לחברי אגודה המשלמים דמי רווחה: 9 שקלים.",
    String lat = "",
    String lon = "",
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