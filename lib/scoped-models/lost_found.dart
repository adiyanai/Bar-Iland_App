import 'dart:convert';

import 'package:bar_iland_app/models/location.dart';
import 'package:bar_iland_app/models/lost_found.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class LostFoundModel extends Model {
  final _lostFoundURL = 'https://bar-iland-app.firebaseio.com/lostFound';
  List<LostFound> _lost = [];
  List<LostFound> _found = [];
  List<String> _lostFoundTypes = [];
  List<Location> lostFoundLocations = [];
  bool isLostFoundLoading = false;

  List<String> get LostFoundTypes {
    return _lostFoundTypes;
  }

  Future<bool> addLostFoundType({String lostFoundType = "אביזרי מחשב"}) async {
    isLostFoundLoading = true;
    notifyListeners();
    final Map<String, dynamic> lostFoundTypeData = {
      'lostFoundType': lostFoundType
    };

    try {
      final http.Response response = await http.post(
          _lostFoundURL + '/lostFoundTypes.json',
          body: json.encode(lostFoundTypeData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        isLostFoundLoading = false;
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (error) {
      isLostFoundLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchLostFoundTypes() {
    isLostFoundLoading = true;
    notifyListeners();
    return http
        .get(_lostFoundURL + '/lostFoundTypes.json')
        .then<Null>((http.Response response) {
      final List<String> fetchedLostFoundTypes = [];
      final Map<String, dynamic> eventTypesData = json.decode(response.body);
      if (eventTypesData == null) {
        isLostFoundLoading = false;
        notifyListeners();
        return;
      }
      eventTypesData
          .forEach((String lostFoundTypeId, dynamic lostFoundTypeData) {
        fetchedLostFoundTypes.add(lostFoundTypeData['lostFoundType']);
      });
      fetchedLostFoundTypes.sort((type1, type2) {
        return type1.compareTo(type2);
      });
      _lostFoundTypes = fetchedLostFoundTypes;
      _lostFoundTypes.add('אחר');
      isLostFoundLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLostFoundLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchLostFoundLocations() {
    isLostFoundLoading = true;
    notifyListeners();
    return http
        .get('https://bar-iland-app.firebaseio.com/locations.json')
        .then<Null>((http.Response response) {
      final List<Location> fetchedLocations = [];
      Map<String, dynamic> locationsTypeData = json.decode(response.body);
      locationsTypeData
          .forEach((String locationType, dynamic locationsTypeData) {
        Location location;
        locationsTypeData.forEach((String id, dynamic locationData) {
          location = Location(
              id: id,
              type: locationType,
              name: locationData['name'],
              number: locationData['number']);
          fetchedLocations.add(location);
        });
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
      isLostFoundLoading = false;
      notifyListeners();
    });
  }
}
