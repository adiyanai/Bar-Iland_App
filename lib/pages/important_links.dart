import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bar_iland_app/models/degree.dart';
import 'package:bar_iland_app/scoped-models/main.dart';

class ImportantLinks extends StatefulWidget {
  final MainModel model;
  ImportantLinks(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ImportantLinksState();
  }
}

class _ImportantLinksState extends State<ImportantLinks> {
  Map<String, SplayTreeMap<String, List<Degree>>> _allData = {};
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    initLinks();
  }

  void initLinks() async {
    await widget.model.fetchAll();
    setState(() {
      // load the data from the model
      _allData = widget.model.allData;
      var entries = _allData.entries.toList();
      // sort the list of data and store it into new map
      entries.sort((MapEntry<String, SplayTreeMap<String, List<Degree>>> a,
              MapEntry<String, SplayTreeMap<String, List<Degree>>> b) =>
          a.key.toString().compareTo(b.key.toString()));
      _allData =
          Map<String, SplayTreeMap<String, List<Degree>>>.fromEntries(entries);
    });
  }

// map betweem faculties and icons
  Map<String, Icon> _mapFacultiesTypesToIcons() {
    Map<String, Icon> eventsToIcons = {
      "הפקולטה להנדסה": Icon(MaterialCommunityIcons.folder),
      "הפקולטה למדעים מדויקים": Icon(MaterialCommunityIcons.folder),
      "מאגרי מידע נוספים": Icon(MaterialCommunityIcons.folder),
      "הפקולטה למדעי הרוח": Icon(MaterialCommunityIcons.folder),
      "לימודים בין תחומיים": Icon(MaterialCommunityIcons.folder),
      "הפקולטה למדעי היהדות": Icon(MaterialCommunityIcons.folder),
      "הפקולטה למדעי החיים": Icon(MaterialCommunityIcons.folder),
      "הפקולטה למדעי החברה": Icon(MaterialCommunityIcons.folder),
    };
    return eventsToIcons;
  }

// create hiper link folder that contains the url that lead to the relevant content
  ListTile _buildhiperlink(Degree d) {
    return ListTile(
        leading: Container(
            padding: EdgeInsets.only(left: 0, right: 33, bottom: 2, top: 5),
            child: Icon(Icons.link)),
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

// create folder of faculty that contains all the hiperlinks
// and folders of the degrees that related to it
  Widget _buildFacultyFolder(String faculty_type,
      SplayTreeMap<String, List<Degree>> degrees_in_faculty) {
    Degree degree;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(left: 4, right: 1, bottom: 3, top: 5.4),
        decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              width: 1.6,
              color: Color.fromRGBO(220, 250, 250, 0.6)),
          color: Color.fromRGBO(200, 230, 230, 0.5),
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent + 50);
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent + 50,
                duration: Duration(milliseconds: 3000),
                curve: Curves.ease);
          },
          leading: _mapFacultiesTypesToIcons()[faculty_type],
          backgroundColor: Color.fromRGBO(220, 250, 250, 0.1),
          title: Text(
            faculty_type,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          children: degrees_in_faculty.keys.map((dynamic department) {
            if (degrees_in_faculty[department].length > 1) {
              degrees_in_faculty[department]
                  .sort((Degree d1, Degree d2) => (d1.name).compareTo(d2.name));
              return ExpansionTile(
                leading: Container(
                    padding:
                        EdgeInsets.only(left: 0, right: 33, bottom: 2, top: 5),
                    child: SizedBox(
                        child: Icon(MaterialCommunityIcons.folder_outline))),
                backgroundColor: Color.fromRGBO(220, 250, 250, 0.4),
                title: Text(
                  department,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: degrees_in_faculty[department].map((degree) {
                  return _buildhiperlink(degree);
                }).toList(),
              );
            } else {
              return _buildhiperlink(degrees_in_faculty[department][0]);
            }
          }).toList(),
        ),
      ),
    );
  }

// create faculties folders for each faculty in the database
  List<Widget> _buildFacultiesFolders(
      Map<String, SplayTreeMap<String, List<Degree>>> allData) {
    List<Widget> list_of_faculties = [];
    allData.forEach((String faculty_type, dynamic degrees_in_faculties) {
      Widget faculty_folder =
          _buildFacultyFolder(faculty_type, degrees_in_faculties);
      list_of_faculties.add(faculty_folder);
    });
    return list_of_faculties;
  }

// set the background image of the page
  Container _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/important_links_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }

//create the page important links
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('קישורים חשובים'),
        ),
        body: Stack(
          children: <Widget>[
            _buildBackgroundImage(),
            widget.model.isLinksLoading || widget.model.isLinksLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    controller: _scrollController,
                    children: _buildFacultiesFolders(_allData),
                  )
          ],
        ),
      ),
    );
  }
}
