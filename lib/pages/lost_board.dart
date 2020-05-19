import 'package:flutter/material.dart';
import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class LostBoard extends StatefulWidget {
  final MainModel model;
  LostBoard(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LostBoardState();
  }
}

class _LostBoardState extends State<LostBoard> {
  String _selLostFoundType = "";
  String _selLostFoundDescription = '';
  @override
  void initState() {
    super.initState();
    widget.model.fetchLostFoundTypes();
    widget.model.fetchServicesLocations();
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
    return Directionality(
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _lostFoundTypeDialog();
                        },
                      );
                    },
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(top: 80),
            child: ListView.builder(
              itemCount: losts.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
        ]),
      ),
    );
  }

  Widget _lostFoundTypeDialog() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text('בחר/י סוג אבידה:'),
        content: SingleChildScrollView(
          child: RadioButtonGroup(
            labels: widget.model.LostFoundTypes,
            onSelected: (String selected) => {_selLostFoundType = selected},
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('הבא'),
            onPressed: () {
              Navigator.of(context).pop();
              _lostFoundDescriptionDialog(context);
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

  Future<String> _lostFoundDescriptionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('תיאור האבידה:'),
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
    List<String> locations = [];
    widget.model.Locations.forEach((location) {
      locations.add(location.Number + " - " + location.Name);
    });
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            child: Stack(children: [
              Container(
                height: 600,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1),
                child: Text(
                  "מקומות משוערים להימצאות האבידה:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 510),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "הבא",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "ביטול",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                height: 500,
                child: ListView(children: [
                  CheckboxGroup(
                    labels: locations,
                    onSelected: (List<String> checked) => {},
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
            ]),
          ),
        );
      },
    );
  }
}
