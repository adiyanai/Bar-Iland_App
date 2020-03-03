import 'package:flutter/material.dart';

class ServiceByBuilding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ServiceByBuildingState();
  }
}

class _ServiceByBuildingState extends State<ServiceByBuilding> {
  String buildingNumber = '';
  String message = '';

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
                      if (buildingNumber != '') {
                        message = ':כל השירותים בבניין' + ' ' + buildingNumber;
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
                onChanged: (String value) => buildingNumber = value,
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
      ],
    );
  }
}
