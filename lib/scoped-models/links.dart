import 'dart:convert';
import 'dart:async';
import 'package:bar_iland_app/models/degree.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class Links extends Model {

List<Degree> _degrees = [];
List<String> _faculties = [];
Map<String,Map<String,List<Degree>>> _fetchedData = {};
bool _isLinksLoading = false;

List<Degree> get allDegrees{
  return List.from(_degrees);
}

List<String> get allFaculties{
  return List.from(_faculties);
}

Map<String,Map<String,List<Degree>>> get allData{
  return (_fetchedData);
}

bool get isLinksLoading {
    return _isLinksLoading;
}

Future<Null> fetchAllDegrees(){
  _isLinksLoading = true;
  return http.get('https://bar-iland-app.firebaseio.com/importantLinks.json')
  .then<Null>((http.Response response){
    final List<Degree> fetchedDegreesList = [];
    final Map<String, dynamic> degreesData = json.decode(response.body);
    if (degreesData == null) {
        _isLinksLoading = false;
        notifyListeners();
        return;
      }
    degreesData.forEach((String facultyType, dynamic facultyData) {
      if (int.tryParse(facultyType) == null){
        Degree degree;
        facultyData.forEach((String idDegree , dynamic dataDegree){
      degree = Degree(
        id: idDegree,
        degreeType :dataDegree['degree'],
        name: dataDegree['name'],
        url: dataDegree['url']);
      fetchedDegreesList.add(degree);
        });
      }
    });
    _degrees = fetchedDegreesList;
    _isLinksLoading = false;
    notifyListeners();
   }).catchError((error) {
      _isLinksLoading = false;
      notifyListeners();
      return;
    });
 }
 
Future<Null> fetchAllFaculties(){
  _isLinksLoading = true;
  return http.get('https://bar-iland-app.firebaseio.com/importantLinks.json')
  .then<Null>((http.Response response){
    final List<String> fetchedFacultiesList = [];
    final Map<String, dynamic> facultiesData = json.decode(response.body);
    if (facultiesData == null) {
        _isLinksLoading = false;
        notifyListeners();
        return;
      }
    facultiesData.forEach((String facultyType, dynamic facultyData) {
      fetchedFacultiesList.add(facultyType);
    });
    _faculties = fetchedFacultiesList;
    _isLinksLoading = false;
    notifyListeners();
  }).catchError((error) {
      _isLinksLoading = false;
      notifyListeners();
      return;
    });
  }
  String convertFacultyType(String facultyName){
      if(facultyName == 'engineering'){
        return 'הנדסה';
      }
      else if(facultyName == 'exactSciences'){
        return 'מדעים מדויקים';
      } 
      else if(facultyName == 'general'){
        return 'כללי';
      } 
      else if(facultyName == 'humanities'){
        return 'מדעי הרוח';
      } 
      else if(facultyName == 'interdisciplinaryStudies'){
        return 'לימודים בין תחומיים';
      } 
      else if(facultyName == 'jewishStudies'){
        return 'מדעי היהדות';
      } 
      else if(facultyName == 'lifeScience'){
        return 'מדעי החיים';
      } 
      else if(facultyName == 'socialSciences'){
        return 'מדעי החברה';
      }
    else{
      return 'invalid faculty name';
    }  
  }
Future<Null> fetchAll(){
  _isLinksLoading = true;
  return http.get('https://bar-iland-app.firebaseio.com/importantLinks.json')
  .then<Null>((http.Response response){
    Map<String,Map<String,List<Degree>>> facultiesToDegrees = {};
    final Map<String, dynamic> allData = json.decode(response.body);
    if (allData == null) {
        _isLinksLoading = false;
        notifyListeners();
        return;
      }
    allData.forEach((String facultyType, dynamic facultyDataMap){
      if (facultyType == null){
        _isLinksLoading = false;
        notifyListeners();
        return;
      }   
        String convertedFacultyType = convertFacultyType(facultyType); 
        Map<String,List<Degree>> degrees_all_data = {};
        
        facultyDataMap.forEach((String facultyId, dynamic degressInFaculty){
            Degree degree = Degree(
                degreeType :degressInFaculty['degree'],
                name: degressInFaculty['name'],
                url: degressInFaculty['url']);
            if(degrees_all_data[degree.degreeType] == null){
              degrees_all_data[degree.degreeType] =[];
              degrees_all_data[degree.degreeType].add(degree);
              facultiesToDegrees[convertedFacultyType] = degrees_all_data;
            }else{
              degrees_all_data[degree.degreeType].add(degree);
              facultiesToDegrees[convertedFacultyType] = degrees_all_data;
            }
        });
       });;
    _fetchedData = facultiesToDegrees;
    
    print(_fetchedData.keys);
    _isLinksLoading = false;
    notifyListeners();
  }).catchError((error) {
      _isLinksLoading = false;
      notifyListeners();
      return;
    }); 
}
}