import 'dart:convert';
import 'dart:async';
import 'package:bar_iland_app/models/degree.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class Links extends Model {
  
List<Degree> _degrees = [];

List <Degree> get DegreesList{
  return _degrees;
}

Future<Null> fetchLinks(){
  return http.get('https://bar-iland-app.firebaseio.com/importantLinks.json')
  .then<Null>((http.Response response){
    final List<Degree> fetcheddegreesList = [];
    final Map<String, dynamic> degreesData = json.decode(response.body);
    degreesData.forEach((String degreeId, dynamic degreeData) {
      final Degree degree = Degree(
        id: degreeId,
        degreeType :degreeData['degree'] ,
        name: degreeData['name'],
        url: degreeData['url']);
      fetcheddegreesList.add(degree);
    });
    _degrees = fetcheddegreesList;
    notifyListeners();
   });
 }

}