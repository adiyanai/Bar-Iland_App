import 'package:flutter/material.dart';

class ServiceByBuilding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ServiceByBuildingState();
  }
}

class _ServiceByBuildingState extends State<ServiceByBuilding> {
  int buildingNumber;
  String message = '';
  List <String> _services = ["מכונת צילום", "קולר", "מכונת קפה", "מכונת חטיפים", "מכונת שתייה", "מיקרוגל", "מקרר", "קופי טיים", "מיחזורית"];

  Widget _showServices() {
    return Column(children: _services.map((service){
      return new Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(8),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color.fromARGB(60, 20, 200, 250),
        border: new Border.all(
          color: Colors.black,
          width: 1.0, 
        ),
      ),
      child: new Text(service, textAlign: TextAlign.right,),
    width: MediaQuery.of(context).size.width,);
    }).toList());
  } 

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 60,
              child: RaisedButton(
                  //color: Colors.blue,
                  //color: Theme.of(context).accentColor,
                  child: Text('הצג'),
                  onPressed: () {
                    setState(() {
                      if (buildingNumber != null) {
                        message = ':כל השירותים בבניין' + ' ' + buildingNumber.toString();
                      } else {
                        message = '';
                      }
                    });
                  }),
            ),
            Container(
              width: 60,
              margin: EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                maxLength: 4,
                onChanged: (String value) => buildingNumber = int.parse(value),
              ),
            ),
            Text(
              ':הכנס מספר בניין',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Center(
          child: Text(message),
        ),
        _showServices()
      ],
    );
  }
}
