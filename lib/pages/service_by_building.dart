import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/service.dart';
import '../scoped-models/main.dart';

class ServiceByBuilding extends StatefulWidget {
  final MainModel _model;
  ServiceByBuilding(this._model);

  @override
  State<StatefulWidget> createState() {
    return _ServiceByBuildingState();
  }
}

class _ServiceByBuildingState extends State<ServiceByBuilding> {
  AutoCompleteTextField<String> _textField;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  final _focusNode = FocusNode();
  String _selectedBuildingNumber;
  bool _isNotPressable = true;
  Color _buttonColor = Colors.grey;
  Future<List<Service>> _servicesList;
  Column _displayedServices = Column();

  void availabilityAlert(int availabilty) {
    String alertText = "";
    if (availabilty == 0) {
      alertText = "השירות יוצג כפעיל";
    } else {
      alertText = "השירות יוצג כלא פעיל";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            child: SizedBox(
              height: 120,
              width: 70,
              child: (Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        alertText,
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            'אישור',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('ביטול',
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchField() {
    return Container(
      height: 120,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'מספר בניין:',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            width: 70,
            child: _textField = AutoCompleteTextField<String>(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              key: _key,
              keyboardType: TextInputType.number,
              clearOnSubmit: false,
              focusNode: _focusNode,
              suggestions: widget._model.buildingNumbers,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
              itemFilter: (buildingNumber, query) {
                return buildingNumber.startsWith(query) &&
                    buildingNumber.length > query.length;
              },
              itemSorter: (buildingNumber1, buildingNumber2) {
                return int.parse(buildingNumber1)
                    .compareTo(int.parse(buildingNumber2));
              },
              itemSubmitted: (buildingNumber) {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _textField.textField.controller.text = buildingNumber;
                  _selectedBuildingNumber = buildingNumber;
                  _isNotPressable = false;
                  _buttonColor = Colors.blue;
                });
              },
              textChanged: (buildingNumber) {
                _selectedBuildingNumber = buildingNumber;
                if (widget._model.buildingNumbers
                    .contains(_selectedBuildingNumber)) {
                  setState(() {
                    _isNotPressable = false;
                    _buttonColor = Colors.blue;
                  });
                } else {
                  setState(() {
                    _isNotPressable = true;
                    _buttonColor = Colors.grey;
                  });
                }
              },
              itemBuilder: (context, buildingNumber) {
                // UI for the autocomplete row
                return Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$buildingNumber'),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
            width: 70,
            child: IgnorePointer(
              ignoring: _isNotPressable,
              child: RaisedButton(
                  color: _buttonColor,
                  //color: Theme.of(context).accentColor,
                  child: Text(
                    'אישור',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (_selectedBuildingNumber != null) {
                        _displayedServices = _showServices(
                            widget._model.services, _selectedBuildingNumber);
                      }
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _showServices(List<Service> services, String buildingNumber) {
    List<Service> servicesInBuilding = [];
    for (int i = 0; i < services.length; i++) {
      if (services[i].BuildingNumber == buildingNumber) {
        servicesInBuilding.add(services[i]);
      }
    }
    if (servicesInBuilding.length == 0) {
      return Center(
        child: Text('לא נמצאו שירותים בבניין ' + buildingNumber.toString()),
      );
    }
    return Column(
        children: servicesInBuilding.map((service) {
      Container availabilityInfo = Container();
      Container reportButton = Container();
      if (service.Availabilty == 0) {
        availabilityInfo = Container(
          width: 110,
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              new IconTheme(
                data: new IconThemeData(color: Colors.red),
                child: new Icon(Icons.cancel),
              ),
              Text("לא פעיל", style: TextStyle(color: Colors.red))
            ],
          ),
        );
        reportButton = Container(
            margin: EdgeInsets.only(right: 100),
            child: FlatButton(
              child: Text(
                "השירות חזר לפעול?",
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
              onPressed: () {
                availabilityAlert(service.Availabilty);
              },
            ));
      } else {
        availabilityInfo = Container(
          width: 100,
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              new IconTheme(
                data: new IconThemeData(color: Colors.green),
                child: new Icon(Icons.check_box),
              ),
              Text("פעיל", style: TextStyle(color: Colors.green))
            ],
          ),
        );
        reportButton = Container(
            margin: EdgeInsets.only(right: 90),
            child: FlatButton(
              child: Text(
                "השירות לא פעיל כרגע?",
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
              onPressed: () {
                availabilityAlert(service.Availabilty);
              },
            ));
      }
      return new ExpansionTile(
        title: Text(service.ServiceType + ", " + service.Location),
        children: <Widget>[
          Row(children: <Widget>[availabilityInfo, reportButton])
        ],
      );
    }).toList());
  }

  @override
  void initState() {
    super.initState();
    _servicesList = widget._model.fetchServices();
  }

  Widget _buildPage(List<Service> services) {
    FocusScope.of(context).autofocus(_focusNode);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: ListView(
            children: <Widget>[_displayedServices],
          ),
        ),
        SingleChildScrollView(
          child: buildSearchField(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
         Widget content;
        if(model.isLoading) {
          content = Center(child: CircularProgressIndicator()); 
        } else {
          content = _buildPage(model.services);
        }
        return RefreshIndicator(onRefresh: model.fetchServices, child: content,);
      },
    );
  }
}
