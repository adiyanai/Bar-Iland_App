import 'package:flutter/material.dart';
import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class LostBoard extends StatefulWidget {
  final MainModel model;
  LostBoard(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LostBoardState();
  }
}

class _LostBoardState extends State<LostBoard> {
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
        Row(children: [mapToIcons["תמונה"],]),
      ]),
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/lost_and_found.jpg'),
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
                    onPressed: () {},
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
}
