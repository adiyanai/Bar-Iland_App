import 'dart:convert';

import 'package:bar_iland_app/models/bar_ilan_location.dart';
import 'package:bar_iland_app/models/lost_found.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class LostFoundModel extends Model {
  final _lostFoundURL = 'https://bar-iland-app.firebaseio.com/lostFound';
  List<LostFound> lostItems = [];
  List<LostFound> foundItems = [];
  List<String> _lostFoundTypes = [];
  List<BarIlanLocation> lostFoundLocations = [];
  bool isLostLoading = false;
  bool isFoundLoading = false;

  List<LostFound> get LostItems {
    return lostItems;
  }

  List<LostFound> get FoundItems {
    return foundItems;
  }

  List<String> get LostFoundTypes {
    return _lostFoundTypes;
  }

  List<BarIlanLocation> get LostFoundLocations {
    return lostFoundLocations;
  }

  Future<bool> addLostFoundType({String lostFoundType = "אביזרי מחשב"}) async {
    isLostLoading = true;
    isFoundLoading = true;
    notifyListeners();
    final Map<String, dynamic> lostFoundTypeData = {
      'lostFoundType': lostFoundType
    };
    try {
      final http.Response response = await http.post(
          _lostFoundURL + '/lostFoundTypes.json',
          body: json.encode(lostFoundTypeData));
      if (response.statusCode != 2008 && response.statusCode != 201) {
        isLostLoading = false;
        isFoundLoading = true;

        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (error) {
      isLostLoading = false;
      isFoundLoading = true;

      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchLostFoundTypes() {
    isLostLoading = true;
    isFoundLoading = true;
    notifyListeners();
    return http
        .get(_lostFoundURL + '/lostFoundTypes.json')
        .then<Null>((http.Response response) {
      final List<String> fetchedLostFoundTypes = [];
      final Map<String, dynamic> lostFoundTypesData =
          json.decode(response.body);
      if (lostFoundTypesData == null) {
        isLostLoading = false;
        isFoundLoading = false;
        notifyListeners();
        return;
      }
      lostFoundTypesData
          .forEach((String lostFoundTypeId, dynamic lostFoundTypeData) {
        fetchedLostFoundTypes.add(lostFoundTypeData['lostFoundType']);
      });
      fetchedLostFoundTypes.sort((type1, type2) {
        return type1.compareTo(type2);
      });
      _lostFoundTypes = fetchedLostFoundTypes;
      _lostFoundTypes.add('אחר');
      isLostLoading = false;
      isFoundLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLostLoading = false;
      isFoundLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchLostFoundLocations() {
    isLostLoading = true;
    isFoundLoading = true;
    notifyListeners();
    return http
        .get('https://bar-iland-app.firebaseio.com/locations.json')
        .then<Null>((http.Response response) {
      final List<BarIlanLocation> fetchedLocations = [];
      Map<String, dynamic> locationsTypeData = json.decode(response.body);
      locationsTypeData
          .forEach((String locationType, dynamic locationsTypeData) {
        if (locationType != "squares" && locationType != "shuttleStations") {
          BarIlanLocation location;
          locationsTypeData.forEach((String id, dynamic locationData) {
            location = BarIlanLocation(
                id: id,
                type: locationType,
                name: locationData['name'],
                number: locationData['number'],
                lon: locationData['lon'],
                lat: locationData['lat']);
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
      lostFoundLocations = fetchedLocations;
      isLostLoading = false;
      isFoundLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchLostItems() {
    isLostLoading = true;
    notifyListeners();
    return http
        .get(_lostFoundURL + '/lost.json')
        .then<Null>((http.Response response) {
      final List<LostFound> fetchedLostItems = [];
      Map<String, dynamic> lostItemsData = json.decode(response.body);
      lostItemsData.forEach((String lostId, dynamic lostData) {
        List<String> optLocations = [];
        (lostData['optionalLocations']).forEach((location) {
          optLocations.add(location);
        });
        Lost lost = Lost(
            id: lostId,
            type: "lost",
            subtype: lostData['subtype'],
            name: lostData['name'],
            phoneNumber: lostData['phoneNumber'],
            description: lostData['description'],
            reportDate: lostData['reportDate'],
            imageUrl: lostData['imageUrl'],
            optionalLocations: optLocations);
        fetchedLostItems.add(lost);
      });
      lostItems = fetchedLostItems.reversed.toList();
      isLostLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchFoundItems() {
    isFoundLoading = true;
    notifyListeners();
    return http
        .get(_lostFoundURL + '/found.json')
        .then<Null>((http.Response response) {
      final List<LostFound> fetchedFoundItems = [];
      Map<String, dynamic> foundItemsData = json.decode(response.body);
      foundItemsData.forEach((String foundId, dynamic foundData) {
        Found lost = Found(
            id: foundId,
            type: "found",
            subtype: foundData['subtype'],
            name: foundData['name'],
            phoneNumber: foundData['phoneNumber'],
            description: foundData['description'],
            reportDate: foundData['reportDate'],
            imageUrl: foundData['imageUrl'],
            area: foundData['area'],
            specificLocation: foundData['specificLocation']);
        fetchedFoundItems.add(lost);
      });
      foundItems = fetchedFoundItems.reversed.toList();
      isFoundLoading = false;
      notifyListeners();
    });
  }

  Future<bool> addLost(
      String type,
      String subtype,
      String name,
      String phoneNumber,
      String description,
      List<String> optionalLocations,
      String imageUrl) async {
    isLostLoading = true;
    notifyListeners();
    if (optionalLocations.length == 0) {
      optionalLocations.add("");
    }
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    final Map<String, dynamic> lostData = {
      'subtype': subtype,
      'name': name,
      'phoneNumber': phoneNumber,
      'description': description,
      'optionalLocations': optionalLocations,
      'reportDate': currentDate,
      'imageUrl': imageUrl
    };
    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/lostFound/${type}.json',
        body: json.encode(lostData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      isLostLoading = false;
      notifyListeners();
      return false;
    }
    isLostLoading = false;
    notifyListeners();
    fetchLostItems();
    return true;
  }

  Future<bool> addFound(
      String type,
      String subtype,
      String name,
      String phoneNumber,
      String description,
      String area,
      String specificLocation,
      String imageUrl) async {
    isFoundLoading = true;
    notifyListeners();
    DateTime today = new DateTime.now();
    String currentDate =
        "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}";
    final Map<String, dynamic> lostData = {
      'subtype': subtype,
      'name': name,
      'phoneNumber': phoneNumber,
      'description': description,
      'area': area,
      'specificLocation': specificLocation,
      'reportDate': currentDate,
      'imageUrl': imageUrl
    };
    final http.Response response = await http.post(
        'https://bar-iland-app.firebaseio.com/lostFound/${type}.json',
        body: json.encode(lostData));
    if (response.statusCode != 200 && response.statusCode != 201) {
      isFoundLoading = false;
      notifyListeners();
      return false;
    }
    isFoundLoading = false;
    notifyListeners();
    fetchFoundItems();
    return true;
  }
}
