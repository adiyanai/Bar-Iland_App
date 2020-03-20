import 'package:searchable_dropdown/searchable_dropdown.dart';

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

  String _selectedBuilding;

  static Widget emptyWidget() {
    return Column();
  }

  Widget displayedServices = emptyWidget();

  List<DropdownMenuItem<String>> buildDropdownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String building in widget.model.BuildingNumbers) {
      items.add(
        DropdownMenuItem(
          value: building,
          child: Container(alignment: Alignment.center, child: Text(building)),
        ),
      );
    }
    return items;
  }

  Widget _showServices(List<Service> services, String buildingNumber) {
    List<String> services_info = [];
    for (int i = 0; i < services.length; i++) {
      if (services[i].BuildingNumber == buildingNumber) {
        services_info
            .add(services[i].serviceType + ', ' + services[i].Location);
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
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(message),
              ),
              displayedServices
            ],
          )),
      SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'מספר בניין:',
                  style: TextStyle(fontSize: 20),
                ),
                /*Container(
                width: 60,
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  maxLength: 4,
                  onChanged: (String value) => buildingNumber = int.parse(value),
                ),
              ),*/
                Container(
                    width: 140,
                    child: SearchableDropdown.single(
                      keyboardType: TextInputType.number,
                      iconSize: 24,
                      dialogBox: false,
                      menuConstraints:
                          BoxConstraints.tight(Size.fromHeight(110)),
                      items: buildDropdownMenuItems(),
                      value: _selectedBuilding,
                      closeButton: SizedBox.shrink(),
                      displayClearIcon: false,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedBuilding = value;
                          if (_selectedBuilding != null) {
                            displayedServices =
                                _showServices(services, _selectedBuilding);
                          } else {
                            message = '';
                          }
                        });
                      },
                    )),

                /*Container(
                  width: 60,
                  child: RaisedButton(
                      //color: Colors.blue,
                      //color: Theme.of(context).accentColor,
                      child: Text('הצג'),
                      onPressed: () {
                        setState(() {
                          if (_selectedBuilding != null) {
                            displayedServices =
                                _showServices(services, _selectedBuilding);
                          } else {
                            message = '';
                          }
                        });
                      }),
                ),*/
              ],
            )),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildPage(model.Services);
      },
    );
  }
}
