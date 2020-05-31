import 'package:bar_iland_app/models/lost_found.dart';
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
    widget.model.fetchLost();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content;
      if (model.isLostFoundLoading) {
        content = Center(child: CircularProgressIndicator());
      } else if (!model.isLostFoundLoading) {
        List<Widget> losts = widget.model.losts.map((lost) {
          Lost specificLost = lost;
          Map<String, Widget> fieldsToWidgets =
              _mapFieldsToWidgets(specificLost);
          return Column(
              children: fieldsToWidgets.keys
                  .map((key) => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: fieldsToWidgets[key]),)
                  .toList());
        }).toList();
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
                child: _buildButtons(),
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
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
      }
      return content;
    });
  }

  Map<String, Widget> _mapFieldsToWidgets(Lost specificLost) {
    Map<String, Icon> mapToIcons = {
      "סוג האבידה": Icon(Icons.search),
      "תיאור": Icon(MaterialCommunityIcons.file_document_edit_outline),
      "תאריך דיווח": Icon(MaterialCommunityIcons.calendar_today),
      "שם": Icon(Icons.person),
      "טלפון": Icon(Icons.phone),
      "מיקום": Icon(Icons.location_on),
      "תמונה": Icon(MaterialCommunityIcons.camera),
    };
    String optionalLocations = "";
    if (specificLost.OptionalLocations.length == 1 &&
        specificLost.OptionalLocations[0] == "") {
      optionalLocations = "";
    } else
      specificLost.OptionalLocations.forEach((location) {
        optionalLocations += ("- " + location + "\n");
      });
    Map<String, Widget> fieldsToWidgets = Map<String, Widget>();
    fieldsToWidgets["סוג האבידה"] =
        Row(children: [mapToIcons["סוג האבידה"], Text(specificLost.Subtype)]);
    if (specificLost.Description != "") {
      fieldsToWidgets["תיאור"] =
          Row(children: [mapToIcons["תיאור"], Text(specificLost.Description)]);
    }
    fieldsToWidgets["תאריך דיווח"] = Row(
        children: [mapToIcons["תאריך דיווח"], Text(specificLost.ReportDate)]);
    fieldsToWidgets["שם"] =
        Row(children: [mapToIcons["שם"], Text(specificLost.Name)]);
    fieldsToWidgets["טלפון"] =
        Row(children: [mapToIcons["טלפון"], Text(specificLost.PhoneNumber)]);
    if (optionalLocations != "") {
      fieldsToWidgets["מיקום"] = Column(
        children: <Widget>[
          Row(children: [mapToIcons["מיקום"], Text("מיקומים משוערים:")]),
          Row(children: [SizedBox(width: 25), Text(optionalLocations)]),
        ],
      );
    }
    if (specificLost.ImageUrl != "") {
      fieldsToWidgets["תמונה"] = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mapToIcons["תמונה"],
          SizedBox(width: 15),
          Container(
            width: 250,
            height: 250,
            child: Image.network(
              specificLost.ImageUrl,
              fit: BoxFit.fill,
            ),
          )
        ],
      );
    }
    return fieldsToWidgets;
  }

  Widget _buildButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      RaisedButton.icon(
        icon: _filterButtonIcon,
        textColor: Colors.white,
        color: Colors.blue,
        label: Text(_filterButtonText),
        onPressed: () {
          setState(() {
            if (_filterButtonText == "סינון") {
              _filterButtonText = "ביטול הסינון";
              _filterButtonIcon = Icon(MaterialCommunityIcons.filter_remove);
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
    ]);
  }
}
