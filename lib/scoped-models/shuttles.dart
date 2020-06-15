import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/shuttle_station.dart';

class ShuttlesModel extends Model {
  final shuttleStationsDatabaseURL =
      'https://bar-iland-app.firebaseio.com/locations/shuttleStations.json';
  List<ShuttleStation> _shuttleStations = [];
  bool _isShuttleStationsLoading = false;

  List<ShuttleStation> get allShuttleStations {
    return List.from(_shuttleStations);
  }

  bool get isShuttleStationsLoading {
    return _isShuttleStationsLoading;
  }

  Future<Null> fetchShuttleStations() {
    _isShuttleStationsLoading = true;
    notifyListeners();
    return http.get(shuttleStationsDatabaseURL).then<Null>((http.Response response) {
      final List<ShuttleStation> fetchedStations = [];
      final Map<String, dynamic> stationsData = json.decode(response.body);
      stationsData.forEach((String stationId, dynamic stationData) {
        ShuttleStation station = ShuttleStation(
          id: stationId,
          number: stationData['number'],
          lat: stationData['lat'],
          lon: stationData['lon'],
        );
        fetchedStations.add(station);
      });
      _shuttleStations = fetchedStations;
      _isShuttleStationsLoading = false;
      notifyListeners();
    }).catchError((error) {
      _isShuttleStationsLoading = false;
      notifyListeners();
      return;
    });
  }
}
