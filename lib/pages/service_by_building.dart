import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  //final ScrollController _scrollController = ScrollController();
  AutoCompleteTextField<String> _textField;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String _selectedBuildingNumber = "";
  bool _isNotPressable = true;
  bool _isOkPressed = false;
  // bool isScrollBar = false;
  Color _buttonColor = Colors.grey;
  Future<List<Service>> _servicesList;
  Widget _displayedServices = Column();
  Widget _addingButton = Container();
  Widget _title = Container();

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

  void okPress() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _title = Container(
        margin: EdgeInsets.fromLTRB(0, 120, 10, 0),
        child: Text(
          "השירותים בבניין " + _selectedBuildingNumber + ":",
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
        ));
    _isOkPressed = true;
    _textField.textField.controller.text = "";
    _buttonColor = Colors.grey;
    if (_selectedBuildingNumber != null) {
      _addingButton = Container(
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
  }

  Widget buildAutoCompleteTextField() {
    return Container(
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
            _isOkPressed = false;
            _title = Container();
            _selectedBuildingNumber = buildingNumber;
            _textField.textField.controller.text = _selectedBuildingNumber;
            _isNotPressable = false;
            _buttonColor = Colors.blue;
          });
        },
        textChanged: (buildingNumber) {
          _isOkPressed = false;
          _title = Container();
          _selectedBuildingNumber = buildingNumber;
          if (widget.model.buildingNumbers.contains(_selectedBuildingNumber)) {
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
    );
  }

  Widget buildingSearch() {
    return Container(
      decoration: BoxDecoration(),
      height: 80,
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'מספר בניין:',
            style: TextStyle(fontSize: 20),
          ),
          buildAutoCompleteTextField(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
            width: 60,
            child: IgnorePointer(
              ignoring: _isNotPressable,
              child: RaisedButton(
                  color: _buttonColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  //color: Theme.of(context).accentColor,
                  child: Text(
                    "הצג",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      okPress();
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

    if (!_isOkPressed) {
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
      Widget availabilityText;
      Widget availabilityIcon;
      Widget reportButton;
      Widget availabilityReportText;
      Map<String, Icon> serviceTypeToIcon = new Map<String, Icon>();
      serviceTypeToIcon["מקרר"] = Icon(Icons.kitchen);
      serviceTypeToIcon["מכונת קפה"] = Icon(MdiIcons.coffeeMaker);
      serviceTypeToIcon["מיקרוגל חלבי"] = Icon(MdiIcons.microwave);
      serviceTypeToIcon["מיקרוגל בשרי"] = Icon(MdiIcons.microwave);
      serviceTypeToIcon["מים חמים"] = Icon(MdiIcons.kettleSteam);
      serviceTypeToIcon["מכונת חטיפים"] = Icon(MdiIcons.cookie);
      serviceTypeToIcon["מכונת שתייה"] =
          Icon(MdiIcons.bottleSodaClassicOutline);
      serviceTypeToIcon["מכונת צילום והדפסה"] = Icon(MdiIcons.printer);

      if (service.Availability == 0) {
        availabilityIcon = IconTheme(
          data: new IconThemeData(color: Colors.red),
          child: new Icon(Icons.cancel),
        );
        availabilityText = Text("לא פעיל", style: TextStyle(color: Colors.red));

        availabilityReportText = Text(
          "השירות חזר לפעול?",
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        );
      } else {
        availabilityIcon = IconTheme(
          data: new IconThemeData(color: Colors.green),
          child: new Icon(Icons.check_box),
        );
        availabilityText = Text("פעיל", style: TextStyle(color: Colors.green));
        availabilityReportText = Text(
          "השירות לא פעיל כרגע?",
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        );
      }

      reportButton = Container(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: availabilityReportText,
              onPressed: () {
                setState(() {
                  availabilityAlert(service);
                });
              },
            ),
          ],
        ),
      );

      availabilityInfo = Container(
        width: 140,
        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: Row(
          children: <Widget>[availabilityIcon, availabilityText],
        ),
      );

      return new Container(
        color: Color.fromRGBO(179, 238, 255, 0.5),
        margin: EdgeInsets.all(7),
        child: ExpansionTile(
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    serviceTypeToIcon[service.serviceType],
                    Text(
                      service.ServiceType,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 22,
                    ),
                    Text(
                      service.Location,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ),
          backgroundColor: Color.fromRGBO(179, 238, 255, 0.5),
          children: <Widget>[
            Row(children: <Widget>[availabilityInfo, reportButton]),
          ],
        ),
      );
    }).toList());
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildPage(List<Service> services) {
    FocusScope.of(context).autofocus(_focusNode);
    return Stack(
      children: <Widget>[
        _title,
        Container(
          padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
          height: 430,
          //child: DraggableScrollbar.arrows(
          //heightScrollThumb: 100,
          //scrollbarAnimationDuration: Duration(milliseconds: 3000),
          //controller: _scrollController,
          //alwaysVisibleScrollThumb: isScrollBar,
          //backgroundColor: Colors.blue,
          child: ListView(
            //controller: _scrollController,
            children: <Widget>[
              _displayedServices = _showServices(
                _selectedBuildingNumber,
                services,
              )
            ],
          ),
        ),
        //_addingButton,
        buildingSearch(),
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
