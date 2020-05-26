import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:bar_iland_app/scoped-models/main.dart';

class LostBoard extends StatefulWidget {
  final MainModel model;
  LostBoard(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LostBoardState();
  }
}

class _LostBoardState extends State<LostBoard> {
  ScrollController _lostScrollController = ScrollController();
  Icon _filterButtonIcon = Icon(MaterialCommunityIcons.filter);
  String _filterButtonText = "סינון";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Icon> mapToIcons = {
      "סוג האבידה": Icon(Icons.search),
      "תיאור": Icon(MaterialCommunityIcons.file_document_edit_outline),
      "תאריך דיווח": Icon(MaterialCommunityIcons.calendar_today),
      "מיקום": Icon(Icons.location_on),
      "תמונה": Icon(MaterialCommunityIcons.camera),
      "טלפון": Icon(Icons.phone),
    };

    List<Widget> losts = List<Widget>.generate(
      10,
      (i) => Column(children: [
        Row(children: [mapToIcons["סוג האבידה"], Text("סוג האבידה...")]),
        Row(children: [mapToIcons["תיאור"], Text("תיאור...")]),
        Row(children: [mapToIcons["תאריך דיווח"], Text("תאריך...")]),
        Row(children: [mapToIcons["מיקום"], Text("מיקום...")]),
        Row(children: [mapToIcons["טלפון"], Text("טלפון...")]),
        Row(children: [
          mapToIcons["תמונה"],
        ]),
      ]),
    );

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content;
      if (!model.isLostFoundLoading) {
        content = Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/lost_found.jpg'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Stack(children: [
              Container(
                height: 40,
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 8),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(210, 245, 250, 0.7),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.blue[200],
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton.icon(
                        icon: _filterButtonIcon,
                        textColor: Colors.white,
                        color: Colors.blue,
                        label: Text(_filterButtonText),
                        onPressed: () {
                          setState(() {
                            if (_filterButtonText == "סינון") {
                              _filterButtonText = "ביטול סינון";
                              _filterButtonIcon =
                                  Icon(MaterialCommunityIcons.filter_remove);
                            } else {
                              _filterButtonText = "סינון";
                              _filterButtonIcon = Icon(MaterialCommunityIcons.filter);
                            }
                          });
                        },
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.add),
                        textColor: Colors.white,
                        color: Colors.blue,
                        label: Text("הוספת אבידה"),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/addLost');
                        },
                      ),
                    ]),
              ),
              Container(
                padding: EdgeInsets.only(top: 80),
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _lostScrollController,
                  child: ListView.builder(
                    controller: _lostScrollController,
                    itemCount: losts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.topRight,
                        margin:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(210, 245, 250, 0.7),
                          border: Border.all(
                            color: Colors.blue[200],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: losts[index],
                      );
                    },
                  ),
                ),
              )
            ]),
          ),
        );
      } else if (model.isLostFoundLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return content;
    });
  }
}
