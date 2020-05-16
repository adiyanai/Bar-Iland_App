import 'package:bar_iland_app/models/degree.dart';
import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportantLinks extends StatefulWidget {
  final MainModel model;
  ImportantLinks(this.model);


  @override
  State<StatefulWidget> createState() {
    return _ImportantLinksState();
  }
}

class _ImportantLinksState extends State<ImportantLinks> {
  Map <String,Map<String,dynamic>> _allData = {};
  @override
  void initState() {
    super.initState();
    initLinks();
  }

  void initLinks() async {
    await widget.model.fetchAll();
    setState(() {
      _allData = widget.model.allData;
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

  ListTile _buildhiperlink(Degree d) {
    return ListTile(
            dense: true,
            enabled: true,
            isThreeLine: false,
            onLongPress: () => print("long press"),
            onTap: () => print("tap"),
            selected: true,
            title: RichText(
              text: TextSpan(
                text: d.Name,
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(d.Url);
                  },
              ),
            ));
  }

 Widget _buildFacultyFolder(String faculty_type,Map<String, List <Degree>> degrees_in_faculty){
   Degree degree;
   return Directionality(
     textDirection: TextDirection.rtl,
     child:ExpansionTile(
     title: Text(convertFacultyType(faculty_type)),
     children:
        degrees_in_faculty.keys.map((dynamic department){
          if(degrees_in_faculty[department].length > 1){
                  return ExpansionTile(
                    title: Text(department),
                    children:degrees_in_faculty[department].map((degree)
                    {return _buildhiperlink(degree);}).toList(),
                    );
          }else{
            return _buildhiperlink(degrees_in_faculty[department][0]);
          }
        }).toList(),
   ));
   
  }

  List<Widget> _buildFacultiesFolders(Map <String,Map<String,dynamic>> allData) {
    List<Widget> list_of_faculties =[];
    allData.forEach((String faculty_type, dynamic degrees_in_faculties){
      Widget faculty_folder = _buildFacultyFolder(faculty_type, degrees_in_faculties);
        list_of_faculties.add(faculty_folder);
    });
    return list_of_faculties;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text('קישורים חשובים'),
              ),
            ),
            body: ListView(children:
              _buildFacultiesFolders(_allData),
            )
            ),)
        );
  }
}