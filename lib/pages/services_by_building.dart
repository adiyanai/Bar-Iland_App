import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bar_iland_app/models/connection.dart';
import 'package:bar_iland_app/services_icons.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
  AutoCompleteTextField<String> _textField;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String _selectedBuildingNumber = "";
  bool _isNotPressable = true;
  bool _isOkPressed = false;
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

  void _registeredUserRefrigeratorReport(
      MachineService service, int updatedAvailability) {
    if (updatedAvailability == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('דיווח על זמינות החלב'),
              content: Text('האם יש חלב במקרר?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('כן'),
                  onPressed: () {
                    setState(() {
                      RefrigeratorService refrigeratorReport = service;
                      widget.model.refrigeratorReport(_selectedBuildingNumber,
                          refrigeratorReport, updatedAvailability, 1);
                      Navigator.of(context).pop();
                    });
                  },
                ),
                FlatButton(
                  child: Text('לא'),
                  onPressed: () {
                    setState(() {
                      widget.model.refrigeratorReport(_selectedBuildingNumber,
                          service, updatedAvailability, 0);
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ),
          );
        },
      );
    } else {
      setState(() {
        widget.model.refrigeratorReport(
            _selectedBuildingNumber, service, updatedAvailability, 0);
      });
    }
  }

  void _registeredUserAvailabilityReport(MachineService service) {
    String alertText = "";
    if (service.Availability == 0) {
      alertText = "השירות יוצג כפעיל";
    } else {
      alertText = "השירות יוצג כלא פעיל";
    }
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int updatedAvailability;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('דיווח על זמינות השירות'),
              content: Text(alertText),
              actions: <Widget>[
                FlatButton(
                  child: Text('אישור'),
                  onPressed: () {
                    if (service.Availability == 0) {
                      updatedAvailability = 1;
                    } else {
                      updatedAvailability = 0;
                    }
                    if (service.Subtype == "מקרר") {
                      Navigator.of(context).pop();
                      setState(() {
                        _registeredUserRefrigeratorReport(
                            service, updatedAvailability);
                      });
                    } else {
                      setState(() {
                        widget.model.availabiltyReport(_selectedBuildingNumber,
                            service, updatedAvailability);
                        Navigator.of(context).pop();
                      });
                    }
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
    });
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

  void _registeredUserMilkReport(
      RefrigeratorService refrigerator, int updatedMilkAvailability) {
    String alertText = "";
    if (updatedMilkAvailability == 0) {
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
                    widget.model.refrigeratorReport(_selectedBuildingNumber,
                        refrigerator, 1, updatedMilkAvailability);
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
    //widget.model.addService();
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
    Map<String, Icon> servicesToIcons = new Map<String, Icon>();
    servicesToIcons["חדר רווחה"] = Icon(ServicesIcons.armchair);
    servicesToIcons["חדר הנקה"] =
        Icon(MaterialCommunityIcons.baby_bottle_outline);
    servicesToIcons["מקרר"] = Icon(Icons.kitchen);
    servicesToIcons["מכונת קפה"] = Icon(MdiIcons.coffeeMaker);
    servicesToIcons["מיקרוגל חלבי"] = Icon(MdiIcons.microwave);
    servicesToIcons["מיקרוגל בשרי"] = Icon(MdiIcons.microwave);
    servicesToIcons["מים חמים"] = Icon(MdiIcons.kettleSteam);
    servicesToIcons["מכונת חטיפים"] = Icon(MdiIcons.cookie);
    servicesToIcons["מכונת שתייה"] = Icon(MdiIcons.bottleSodaClassicOutline);
    servicesToIcons["מכונת צילום והדפסה"] = Icon(MdiIcons.printer);
    servicesToIcons["פינות ישיבה ושולחנות"] = Icon(MaterialCommunityIcons.sofa);
    servicesToIcons["נדנדה"] = Icon(ServicesIcons.swing);
    servicesToIcons["מטבחון"] = Icon(MaterialCommunityIcons.water_pump);
    servicesToIcons["משטחי החתלה"] = Icon(MdiIcons.humanBabyChangingTable);
    return servicesToIcons;
  }

  Widget _milkUI(MachineService service) {
    RefrigeratorService refrigerator = service;
    Widget milkInfo;
    Widget milkText;
    Widget milkIcon;
    Widget milkReportButton;
    Widget milkReportText;
    if (refrigerator.Availability == 0) {
      return Row();
    }
    if (refrigerator.Milk == 1) {
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
        "מלאי החלב התחדש?",
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
                int updatedMilkAvailability;
                if (refrigerator.Milk == 1) {
                  updatedMilkAvailability = 0;
                } else {
                  updatedMilkAvailability = 1;
                }
                _connectionMode == ConnectionMode.RegisteredUser
                    ? _registeredUserMilkReport(
                        refrigerator, updatedMilkAvailability)
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
    return Column(
      children: <Widget>[
        Row(children: <Widget>[milkInfo, milkReportButton]),
        Container(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            children: <Widget>[
              Text("דווח לאחרונה: " +
                  refrigerator.MilkReportDate +
                  ", " +
                  refrigerator.MilkReportTime)
            ],
          ),
        )
      ],
    );
  }

  Widget _availabilityUI(MachineService service) {
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

    return Column(
      children: <Widget>[
        Row(children: <Widget>[availabilityInfo, availabilityReportButton]),
        Container(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            children: <Widget>[
              Text("דווח לאחרונה: " + service.AvailabilityReportDate)
            ],
          ),
        )
      ],
    );
  }

  List<Widget> expansionTileContent(Service service) {
    if (service.Type == "self-service-facilities") {
      Widget milkInfo;
      if (service.Subtype == "מקרר") {
        milkInfo = _milkUI(service);
      } else {
        milkInfo = Row();
      }
      return <Widget>[
        _availabilityUI(service),
        milkInfo,
      ];
    } else if (service.Type == "welfare-rooms") {
      WelfareRoomService welfareRoom = service;
      return [
        Container(
            padding: EdgeInsets.fromLTRB(230, 0, 0, 0),
            child: Text("החדר מכיל:")),
        ...welfareRoom.Contains.map((containedService) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 22, 0),
            child: Row(children: [
              mapServicesToIcons()[containedService],
              Text(
                containedService,
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ]),
          );
        }).toList()
      ];
    } else
      return <Widget>[];
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
      String serviceLocation = service.Location;
      serviceLocation = serviceLocation.replaceAll("קומה -1", "קומה 1-");
      Map<String, Icon> servicesToIcons = mapServicesToIcons();

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
                    servicesToIcons[service.Subtype],
                    Text(
                      service.Subtype,
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
                      serviceLocation,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ),
          backgroundColor: Color.fromRGBO(179, 238, 255, 0.5),
          children: expansionTileContent(service),
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
        if (!model.isLoading) {
          content = _buildPage(model.services);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchServices,
          child: content,
        );
      },
    );
  }
}
