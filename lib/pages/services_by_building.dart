import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bar_iland_app/models/connection.dart';
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
  ConnectionMode _connectionMode;

  @override
  void initState() {
    super.initState();
    _connectionMode = widget.model.connectionMode;
  }

  void _guestUserAvailabilityReport() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('דיווח על זמינות השירות'),
              content: Text("פעולה זו אפשרית עבור משתמשים רשומים בלבד"),
              actions: <Widget>[
                FlatButton(
                  child: Text('אישור'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  void _registeredUserAvailabilityReport(Service service) {
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
          child: AlertDialog(
            title: Text('דיווח על זמינות השירות'),
            content: Text(alertText),
            actions: <Widget>[
              FlatButton(
                child: Text('אישור'),
                onPressed: () {
                  setState(() {
                    widget.model
                        .availabiltyReport(_selectedBuildingNumber, service);
                    widget.model.fetchServices();
                  });
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('ביטול'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _guestUserMilkReport() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('דיווח על זמינות החלב'),
              content: Text("פעולה זו אפשרית עבור משתמשים רשומים בלבד"),
              actions: <Widget>[
                FlatButton(
                  child: Text('אישור'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  void _registeredUserMilkReport(RefrigeratorService refrigerator) {
    String alertText = "";
    if (refrigerator.Milk == 1) {
      alertText = "החלב במקרר יוצג כלא זמין";
    } else {
      alertText = "החלב במקרר יוצג כזמין";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('דיווח על זמינות החלב'),
            content: Text(alertText),
            actions: <Widget>[
              FlatButton(
                child: Text('אישור'),
                onPressed: () {
                  setState(() {
                    widget.model
                        .milkReport(_selectedBuildingNumber, refrigerator);
                    widget.model.fetchServices();
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                child: Text('ביטול'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _showPress() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _title = Container(
      margin: EdgeInsets.fromLTRB(0, 120, 10, 0),
      child: Text(
        "השירותים בבניין " + _selectedBuildingNumber + ":",
        style: TextStyle(
            color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
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

  Widget _buildAutoCompleteTextField() {
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

  Widget _buildingSearch() {
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
          _buildAutoCompleteTextField(),
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
                      _showPress();
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }

  Map<String, Icon> mapServicesToIcons() {
    Map<String, Icon> serviceTypeToIcon = new Map<String, Icon>();
    serviceTypeToIcon["מקרר"] = Icon(Icons.kitchen);
    serviceTypeToIcon["מכונת קפה"] = Icon(MdiIcons.coffeeMaker);
    serviceTypeToIcon["מיקרוגל חלבי"] = Icon(MdiIcons.microwave);
    serviceTypeToIcon["מיקרוגל בשרי"] = Icon(MdiIcons.microwave);
    serviceTypeToIcon["מים חמים"] = Icon(MdiIcons.kettleSteam);
    serviceTypeToIcon["מכונת חטיפים"] = Icon(MdiIcons.cookie);
    serviceTypeToIcon["מכונת שתייה"] = Icon(MdiIcons.bottleSodaClassicOutline);
    serviceTypeToIcon["מכונת צילום והדפסה"] = Icon(MdiIcons.printer);
    return serviceTypeToIcon;
  }

  Widget _milkUI(Service service) {
    RefrigeratorService refrigerator = service;
    Widget milkInfo;
    Widget milkText;
    Widget milkIcon;
    Widget milkReportButton;
    Widget milkReportText;
    if (refrigerator.milk == 1) {
      milkText = Text(
        "יש חלב במקרר",
        style: TextStyle(
          color: Colors.green,
        ),
      );
      milkReportText = Text(
        "נגמר החלב?",
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      );
      milkIcon = Image(
          image: AssetImage('assets/available_milk.png'),
          height: 20,
          width: 20);
    } else {
      milkIcon = Image(
          image: AssetImage('assets/unavailable_milk.png'),
          height: 20,
          width: 20);
      milkText = Text(
        "אין חלב במקרר",
        style: TextStyle(
          color: Colors.red,
        ),
      );
      milkReportText = Text(
        "המקרר התמלא בחלב?",
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      );
    }

    milkReportButton = Container(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: milkReportText,
            onPressed: () {
              setState(() {
                _connectionMode == ConnectionMode.RegisteredUser
                    ? _registeredUserMilkReport(refrigerator)
                    : _guestUserMilkReport();
              });
            },
          ),
        ],
      ),
    );

    milkInfo = Container(
      width: 140,
      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Row(
        children: <Widget>[milkIcon, milkText],
      ),
    );
    return Row(children: <Widget>[milkInfo, milkReportButton]);
  }

  Widget _availabilityUI(Service service) {
    Widget availabilityInfo;
    Widget availabilityIcon;
    Widget availabilityText;
    Widget availabilityReportButton;
    Widget availabilityReportText;
    if (service.Availability == 0) {
      availabilityIcon = IconTheme(
        data: new IconThemeData(color: Colors.red),
        child: new Icon(Icons.cancel),
      );
      availabilityText = Text("לא פעיל", style: TextStyle(color: Colors.red));
      availabilityReportText = Text(
        "השירות חזר לפעול?",
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      );
    } else {
      availabilityIcon = IconTheme(
        data: new IconThemeData(color: Colors.green),
        child: new Icon(Icons.check_box),
      );
      availabilityText = Text("פעיל", style: TextStyle(color: Colors.green));
      availabilityReportText = Text(
        "השירות לא פעיל כרגע?",
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      );
    }

    availabilityReportButton = Container(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: availabilityReportText,
            onPressed: () {
              setState(() {
                _connectionMode == ConnectionMode.RegisteredUser
                    ? _registeredUserAvailabilityReport(service)
                    : _guestUserAvailabilityReport();
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

    return Row(children: <Widget>[availabilityInfo, availabilityReportButton]);
  }

  Widget _showServices(String buildingNumber, List<Service> services) {
    List<Service> servicesInBuilding = [];
    for (int i = 0; i < services.length; i++) {
      if (services[i].BuildingNumber == buildingNumber) {
        servicesInBuilding.add(services[i]);
      }
    }
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
      Widget milkInfo;
      if (service.ServiceType == "מקרר") {
        milkInfo = _milkUI(service);
      } else {
        milkInfo = Row();
      }
      Map<String, Icon> serviceTypeToIcon = mapServicesToIcons();
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
            _availabilityUI(service),
            milkInfo,
          ],
        ),
      );
    }).toList());
  }

  Widget _buildPage(List<Service> services) {
    FocusScope.of(context).autofocus(_focusNode);
    return Stack(
      children: <Widget>[
        _title,
        Container(
          padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
          height: 430,
          child: ListView(
            children: <Widget>[
              _displayedServices = _showServices(
                _selectedBuildingNumber,
                services,
              )
            ],
          ),
        ),
        //_addingButton,
        _buildingSearch(),
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
