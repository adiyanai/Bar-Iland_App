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
      print(_allData);
    });

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
       
     backgroundColor:Colors.cyan[50].withOpacity(0.6),
     title: Text(
      faculty_type,
      style:TextStyle(
        //fontFamily: 'VarelaRound',
        fontWeight:FontWeight.bold,
        fontSize: 18,
        
      )),
     children:
        degrees_in_faculty.keys.map((dynamic department){
          if(degrees_in_faculty[department].length > 1){
                  return ExpansionTile(
                    backgroundColor:Colors.cyan[50].withOpacity(0.6),
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

Container _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/important_links_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: 
                Text('קישורים חשובים   '),
            ),
            
            body: Stack(
              children: <Widget>[
                _buildBackgroundImage(),
                widget.model.isLinksLoading ||
                          widget.model.isLinksLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(children:
                          _buildFacultiesFolders(_allData),
            )
              ],

            ),
             
            ),
            );
        
  }
}