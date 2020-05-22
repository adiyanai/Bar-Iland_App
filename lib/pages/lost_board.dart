import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
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
  ScrollController _typesScrollController = ScrollController();
  ScrollController _locationsScrollController = ScrollController();
  String _selLostFoundType = "";
  String _selLostFoundDescription = "";
  List<String> _selOptionalLostLocations = [];
  String _phoneNumber = "";

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
                decoration: BoxDecoration(
                  color: Color.fromRGBO(210, 245, 250, 0.7),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.blue[200],
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton.icon(
                        icon: Icon(MaterialCommunityIcons.filter),
                        textColor: Colors.white,
                        color: Colors.blue,
                        label: Text("סינון"),
                        onPressed: () {},
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.add),
                        textColor: Colors.white,
                        color: Colors.blue,
                        label: Text("הוספת אבידה"),
                        onPressed: () {
                           Navigator.pushReplacementNamed(
                          context, '/addLost');
                          /*
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return _lostFoundTypeDialog();
                            },
                          );
                          */
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

  Widget _lostFoundTypeDialog() {
    _selLostFoundType = "";
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Container(
            padding: EdgeInsets.all(5), child: Text('מהו סוג האבידה?')),
        contentPadding: EdgeInsets.all(5),
        content: Scrollbar(
            isAlwaysShown: true,
            controller: _typesScrollController,
            child: ListView(controller: _typesScrollController, children: [
              Container(
                child: RadioButtonGroup(
                  padding: EdgeInsets.only(right: 0),
                  labels: widget.model.LostFoundTypes,
                  onSelected: (String selected) =>
                      {_selLostFoundType = selected},
                ),
              )
            ])),
        actions: <Widget>[
          FlatButton(
            child: Text('הבא'),
            onPressed: () {
              if (_selLostFoundType != "") {
                Navigator.of(context).pop();
                _lostFoundDescriptionDialog();
              }
            },
          ),
          FlatButton(
            child: Text('ביטול'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<String> _lostFoundDescriptionDialog() async {
    _selLostFoundDescription = "";
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('תיאור האבידה:'),
                Text('(לא חובה)',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        hintText: "תיאור כללי וסימנים ייחודיים"),
                    onChanged: (value) {
                      _selLostFoundDescription = value;
                    },
                  ),
                )
              ],
            ),
            actions: <Widget>[
              /*
              FlatButton(
                child: Text('הקודם'),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return _lostFoundTypeDialog();
                    },
                  );
                },
              ),
              */
              FlatButton(
                child: Text('הבא'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _lostFoundLocationDialog(context);
                },
              ),
              FlatButton(
                child: Text('ביטול'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _lostFoundLocationDialog(BuildContext context) async {
    _selOptionalLostLocations = [];
    List<String> lostFoundLocations = [];
    widget.model.LostFoundLocations.forEach((location) {
      lostFoundLocations.add(location.Number + " - " + location.Name);
    });
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(5),
            content: Stack(children: [
              Container(
                height: 600,
                padding: EdgeInsets.fromLTRB(0, 20, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "היכן ייתכן שהאבידה נמצאת?",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('(לא חובה)',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                height: 500,
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _locationsScrollController,
                  child: ListView(
                      controller: _locationsScrollController,
                      children: [
                        CheckboxGroup(
                          labels: lostFoundLocations,
                          onSelected: (List<String> checked) =>
                              {_selOptionalLostLocations = checked},
                          itemBuilder: (Checkbox cb, Text txt, int i) {
                            Text text = Text(
                              txt.data,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            );
                            return Row(
                              children: <Widget>[
                                cb,
                                text,
                              ],
                            );
                          },
                        )
                      ]),
                ),
              )
            ]),
            actions: <Widget>[
              /*
              FlatButton(
                child: Text('הקודם'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _lostFoundDescriptionDialog();
                },
              ),
              */
              FlatButton(
                child: Text('הבא'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _lostFoundContactDialog(context);
                },
              ),
              FlatButton(
                child: Text('ביטול'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _lostFoundContactDialog(BuildContext context) async {
    _phoneNumber = "";
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('טלפון ליצירת קשר:'),
                  Text('(יוצג לשאר משתמשי האפליקציה)',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ]),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: new InputDecoration(icon: Icon(Icons.phone)),
                    onChanged: (value) {
                      _phoneNumber = value;
                    },
                  ),
                )
              ],
            ),
            actions: <Widget>[
              /*
              FlatButton(
                child: Text('הקודם'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _lostFoundLocationDialog(context);
                },
              ),
              */
              FlatButton(
                child: Text('הבא'),
                onPressed: () {
                  if (_phoneNumber != "" && _phoneNumber.length >= 9) {
                    widget.model.addLost(
                        "lost",
                        _selLostFoundType,
                        _selLostFoundDescription,
                        _phoneNumber,
                        _selOptionalLostLocations);
                    Navigator.of(context).pop();
                  }
                },
              ),
              FlatButton(
                child: Text('ביטול'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
