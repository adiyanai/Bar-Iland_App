import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
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
  AutoCompleteTextField<String> _textField;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  final ScrollController scrollController = ScrollController();
  final _focusNode = FocusNode();
  String _selectedBuildingNumber = "";
  bool _isNotPressable = true;
  bool isOkPressed = false;
  // bool isScrollBar = false;
  Color _buttonColor = Colors.grey;
  Future<List<Service>> _servicesList;
  Widget _displayedServices = Column();
  Widget addingButton = Container();
  Widget title = Container();

  void availabilityAlert(Service service) {
    String alertText = "";
    if (service.Availability == 0) {
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
                    ),
                  ),
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
                            setState(() {
                              widget.model.availabiltyReport(
                                  _selectedBuildingNumber, service);
                              widget.model.fetchServices();
                            });
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
              suggestions: widget.model.buildingNumbers,
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
                  isOkPressed = false;
                  title = Container();
                  _selectedBuildingNumber = buildingNumber;
                  _textField.textField.controller.text =
                      _selectedBuildingNumber;
                  _isNotPressable = false;
                  _buttonColor = Colors.blue;
                });
              },
              textChanged: (buildingNumber) {
                isOkPressed = false;
                title = Container();

                _selectedBuildingNumber = buildingNumber;
                if (widget.model.buildingNumbers
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
                      title = Container(
                          margin: EdgeInsets.fromLTRB(0, 120, 10, 0),
                          child: Text(
                            "השירותים בבניין " + _selectedBuildingNumber + ":",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ));
                      isOkPressed = true;
                      _textField.textField.controller.text = "";
                      _buttonColor = Colors.grey;
                      if (_selectedBuildingNumber != null) {
                        addingButton = Container(
                          padding: EdgeInsets.fromLTRB(0, 430, 270, 0),
                          child: RawMaterialButton(
                            shape: new CircleBorder(),
                            fillColor: Colors.blue,
                            padding: const EdgeInsets.all(3),
                            onPressed: () {
                              //widget._model.addService();
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        );
                      }
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _showServices(String buildingNumber, List<Service> services) {
    List<Service> servicesInBuilding = [];
    for (int i = 0; i < services.length; i++) {
      if (services[i].BuildingNumber == buildingNumber) {
        servicesInBuilding.add(services[i]);
      }
    }
    /*
    if(servicesInBuilding.length >= 5) {
      isScrollBar = true;
    }
    */

    if (!isOkPressed) {
      return Column();
    }

    if (servicesInBuilding.length == 0) {
      return Center(
        child: Text('לא נמצאו שירותים בבניין ' + buildingNumber.toString()),
      );
    }

    return Column(
        children: servicesInBuilding.map((service) {
      Widget availabilityInfo = Container();
      Widget availabilityLabel;
      Widget reportButton = Container();
      if (service.Availability == 0) {
        availabilityLabel = Row(
          children: <Widget>[
            new IconTheme(
              data: new IconThemeData(color: Colors.red),
              child: new Icon(Icons.cancel),
            ),
            Text("לא פעיל", style: TextStyle(color: Colors.red))
          ],
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
              setState(() {
                availabilityAlert(service);
              });
            },
          ),
        );
      } else {
        availabilityLabel = Row(
          children: <Widget>[
            new IconTheme(
              data: new IconThemeData(color: Colors.green),
              child: new Icon(Icons.check_box),
            ),
            Text("פעיל", style: TextStyle(color: Colors.green))
          ],
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
              availabilityAlert(service);
            },
          ),
        );
      }
      availabilityInfo = Container(
        width: 100,
        padding: EdgeInsets.all(10),
        child: availabilityLabel,
      );
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
    widget.model.fetchServices();
  }

  Widget _buildPage(List<Service> services) {
    FocusScope.of(context).autofocus(_focusNode);
    return Stack(
      children: <Widget>[
        title,
        Container(
          padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
          height: 430,
          //child: DraggableScrollbar.arrows(
          //heightScrollThumb: 100,
          //scrollbarAnimationDuration: Duration(milliseconds: 3000),
          //controller: scrollController,
          //alwaysVisibleScrollThumb: isScrollBar,
          //backgroundColor: Colors.blue,
          child: ListView(
            //controller: scrollController,
            children: <Widget>[
              _displayedServices = _showServices(
                _selectedBuildingNumber,
                services,
              )
            ],
          ),
        ),
        //addingButton,
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
        if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        } else {
          content = _buildPage(model.services);
        }
        return content;
      },
    );
  }
}
