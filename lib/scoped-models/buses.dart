import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/bus.dart';
import '../models/station.dart';

class BusesModel extends Model {
  final busesDatabaseURL = 'https://bar-iland-app.firebaseio.com/buses.json';
  final stationsDatabaseURL =
      'https://bar-iland-app.firebaseio.com/stations.json';
  List<Bus> _buses = [];
  List<Station> _stations = [];
  List<String> _busesLocations = [];
  bool _isBusesLoading = false;
  bool _isStationsLoading = false;

  List<Bus> get allBuses {
    return List.from(_buses);
  }

  List<Station> get allStations {
    return List.from(_stations);
  }

  List<String> get busesLocations {
    return _busesLocations;
  }

  bool get isBusesLoading {
    return _isBusesLoading;
  }

  bool get isStationsLoading {
    return _isStationsLoading;
  }

  Future<Null> fetchBuses() {
    _isBusesLoading = true;
    notifyListeners();
    return http.get(busesDatabaseURL).then<Null>((http.Response response) {
      final List<String> busesLocations = [];
      final List<Bus> fetchedBuses = [];
      final Map<String, dynamic> busesData = json.decode(response.body);
      busesData.forEach((String busId, dynamic busData) {
        List<String> citiesBetween = [];
        // get all the citiesBetween
        (busData['citiesBetween']).forEach((city) {
          citiesBetween.add(city);
          if (!busesLocations.contains(city)) {
            busesLocations.add(city);
          }
        });
        if (!busesLocations.contains(busData['origin'])) {
          busesLocations.add(busData['origin']);
        }
        if (!busesLocations.contains(busData['destination'])) {
          busesLocations.add(busData['destination']);
        }
        Bus bus = Bus(
            id: busId,
            number: busData['number'],
            origin: busData['origin'],
            destination: busData['destination'],
            moovitUrl: busData['moovitUrl'],
            citiesBetween: citiesBetween);
        fetchedBuses.add(bus);
      });
      _buses = fetchedBuses;
      _busesLocations = busesLocations;
      _isBusesLoading = false;
      notifyListeners();
    }).catchError((error) {
      _isBusesLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchStations() {
    _isStationsLoading = true;
    notifyListeners();
    return http.get(stationsDatabaseURL).then<Null>((http.Response response) {
      final List<Station> fetchedStations = [];
      final Map<String, dynamic> stationsData = json.decode(response.body);
      stationsData.forEach((String stationId, dynamic stationData) {
        List<String> stationBuses = [];
        // get all the buses in the station
        (stationData['buses']).forEach((bus) {
          stationBuses.add(bus);
        });
        Station station = Station(
            id: stationId,
            number: stationData['number'],
            name: stationData['name'],
            closestGate: stationData['closestGate'],
            lat: stationData['lat'],
            lon: stationData['lon'],
            buses: stationBuses);
        fetchedStations.add(station);
      });
      _stations = fetchedStations;
      _isStationsLoading = false;
      notifyListeners();
    }).catchError((error) {
      _isStationsLoading = false;
      notifyListeners();
      return;
    });
  }
}
