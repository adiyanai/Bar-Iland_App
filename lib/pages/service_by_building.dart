import 'package:bar_iland_app/scoped-models/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/service.dart';
import '../scoped-models/main.dart';

class ServiceByBuilding extends StatefulWidget {
  final MainModel model;
  ServiceByBuilding(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ServiceByBuildingState();
  }
}

class _ServiceByBuildingState extends State<ServiceByBuilding> {
  int buildingNumber;
  String message = '';

  Future<List<Service>> _servicesList;

  static Widget emptyWidget() {
    return Column();
  }

  Widget displayedServices = emptyWidget();

  Widget _showServices(List<Service> services, int buildingNumber) {
    List<String> services_info = [];
    for (int i = 0; i < services.length; i++) {
      if (int.parse(services[i].BuildingNumber) == buildingNumber) {
        services_info.add(services[i].serviceType);
      }
    }
    if (services_info.length == 0) {
      return Center(
        child: Text('לא נמצאו שירותים בבניין ' + buildingNumber.toString()),
      );
    }
    return Column(
        children: services_info.map((service) {
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
        child: new Text(
          service,
          textAlign: TextAlign.right,
        ),
        width: MediaQuery.of(context).size.width,
      );
    }).toList());
  }

  @override
  void initState() {
    super.initState();
    _servicesList = widget.model.fetchServices();
  }

  Widget _buildPage(List<Service> services) {
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
                        displayedServices =
                            _showServices(services, buildingNumber);
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
        displayedServices
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildPage(model.services);
      },
    );
  }
}
