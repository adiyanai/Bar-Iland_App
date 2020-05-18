import 'dart:convert';

import 'package:bar_iland_app/models/lost_found.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class LostFoundModel extends Model {
  final _lostFoundURL = 'https://bar-iland-app.firebaseio.com/lostFound';
  List<LostFound> _lost = [];
  List<LostFound> _found = [];
  List<String> _lostFoundTypes = [];
  List<String> _lostFoundLocations = [];
  bool _isLostFoundLoading = false;

  Future<bool> addLostFoundType({String lostFoundType = "אביזרי מחשב"}) async {
    _isLostFoundLoading = true;
    notifyListeners();
    final Map<String, dynamic> lostFoundTypeData = {
      'lostFoundType': lostFoundType
    };

    try {
      final http.Response response = await http.post(
          _lostFoundURL + '/lostFoundTypes.json',
          body: json.encode(lostFoundTypeData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLostFoundLoading = false;
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (error) {
      _isLostFoundLoading = false;
      notifyListeners();
      return false;
    }
  }
}
