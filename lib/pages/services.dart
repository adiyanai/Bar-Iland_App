import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bar_iland_app/models/connection.dart';
import 'package:bar_iland_app/services_icons.dart';
import 'package:bar_iland_app/widgets/services_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/service.dart';
import '../scoped-models/main.dart';

class Services extends StatefulWidget {
  final MainModel model;
  final String servicesView;
  Services(this.model, this.servicesView);

  @override
  State<StatefulWidget> createState() {
    model.ServicesView = servicesView;
    return _ServicesState();
  }
}

class _ServicesState extends State<Services> {
  ConnectionMode _connectionMode;
  Future<List<Service>> _servicesList;
  Widget _displayedServicesByArea = Column();
  ListView _servicesListView;
  Map<String, Icon> _mapServicesToIcons;
  AutoCompleteTextField<String> _textField;
  Widget _addingButton = Container();
  Widget _title = Container();
  ScrollController _scrollController;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String _selectedArea = "";
  bool _isNotPressable = true;
  bool _isSearchPressed = false;
  Color _buttonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _connectionMode = widget.model.connectionMode;
    _mapServicesToIcons = mapToIcons();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content;
        if (!model.isServicesLoading) {
          switch (model.ServicesView) {
            case "לפי מיקום":
              content = _buildServicesByAreaPage(model.services);
              break;
            case "לפי סוג שירות":
              content = _buildServicesByTypePage();
              break;
            default:
              content = WillPopScope(
                onWillPop: () {
                  model.ServicesView = "לפי סוג שירות";
                  Navigator.pop(context, false);
                  return Future.value(false);
                },
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 40),
                        child: Center(
                          child: Text(
                            model.ServicesView,
                          ),
                        ),
                      ),
                    ),
                    body: Stack(
                      children: [
                        Container(
                          child: _buildSpecificServiceTypePage(
                              model.ServicesView, model.services),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 55, 15, 0),
                          width: 145,
                          child: RaisedButton.icon(
                            icon: Icon(Icons.location_on),
                            textColor: Colors.white,
                            color: Colors.blue,
                            label: const Text("מיון לפי מיקום"),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              break;
          }
        } else if (model.isServicesLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return content;
      },
    );
  }

  Widget serviceTypeButton(String text, Icon icon) {
    return SizedBox.fromSize(
      size: Size(95, 95),
      child: ClipOval(
        child: Material(
          color: Colors.lightBlue[200],
          child: InkWell(
            splashColor: Colors.cyanAccent,
            onTap: () {
              widget.model.ServicesView = text;
              Navigator.pushNamed(context, '/services');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                Text(text,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesByTypePage() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/services_by_type_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.55),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: <Widget>[
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  serviceTypeButton(
                      "בתי קפה ומסעדות", _mapServicesToIcons["בית קפה"]),
                  serviceTypeButton(
                      "חנויות ועסקים", Icon(Icons.business_center)),
                  serviceTypeButton(
                      "מזכירויות ומנהלה", Icon(MdiIcons.officeBuilding)),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  serviceTypeButton("ספריות", Icon(MdiIcons.library)),
                  serviceTypeButton("חדרי הנקה",
                      Icon(MaterialCommunityIcons.baby_bottle_outline)),
                  serviceTypeButton(
                    "חדרי רווחה",
                    Icon(ServicesIcons.armchair, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  serviceTypeButton("פינות קפה", Icon(MdiIcons.coffeeMaker)),
                  serviceTypeButton("מים חמים", Icon(MdiIcons.kettleSteam)),
                  serviceTypeButton(
                    "מקררים",
                    Icon(Icons.kitchen),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  serviceTypeButton("מיקרוגלים", Icon(MdiIcons.microwave)),
                  serviceTypeButton("מכונות חטיפים", Icon(MdiIcons.cookie)),
                  serviceTypeButton(
                      "מכונות שתייה", Icon(MdiIcons.bottleSodaClassicOutline)),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  serviceTypeButton("מעבדות מחשבים", Icon(Icons.computer)),
                  serviceTypeButton("מניינים",
                      Icon(MaterialCommunityIcons.book_open_page_variant)),
                  serviceTypeButton(
                      "שערים ואבטחה", Icon(MaterialCommunityIcons.gate)),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  serviceTypeButton("מכשירי החייאה", Icon(MdiIcons.medicalBag)),
                  serviceTypeButton(
                      "שירותי צילום והדפסה", Icon(MdiIcons.printer)),
                  serviceTypeButton("קולרים", Icon(MdiIcons.waterPump)),
                ],
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesByAreaPage(List<Service> services) {
    //FocusScope.of(context).autofocus(_focusNode);
    _scrollController = ScrollController(
        initialScrollOffset: (widget.model.SelectedServiceIndex - 1) * 35.0);
    _servicesListView = ListView(
      controller: _scrollController,
      children: <Widget>[
        _displayedServicesByArea = _showServicesByArea(
          (_selectedArea.split(" - "))[0],
          services,
        )
      ],
    );
    return Stack(
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/Bar_Ilan_Mini_Map.jpg"),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.9), BlendMode.softLight),
              ),
            ),
            padding: EdgeInsets.fromLTRB(0, 140, 0, 0),
            height: 600,
            child: _servicesListView),
        _title,
        //_addingButton,
        _locationSearch(),
      ],
    );
  }

  Widget _showServicesByArea(String area, List<Service> services) {
    List<Service> servicesInArea = [];
    for (int i = 0; i < services.length; i++) {
      if (area == (services[i].Area)) {
        servicesInArea.add(services[i]);
      }
    }
    if (!_isSearchPressed) {
      return Column();
    }
    if (servicesInArea.length == 0) {
      return Center(
        child: Container(
          width: 600,
          height: 100,
          color: Color.fromRGBO(200, 230, 230, 0.7),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: EdgeInsets.all(20),
          child: Text(
            'לא נמצאו שירותים באזור זה',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    return _createServicesList(servicesInArea);
  }

  Widget _createServicesList(List<Service> servicesList) {
    int expansionTileIndex = 0;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Column(
          children: servicesList.map((service) {
        expansionTileIndex += 1;
        int currExpansionTileIndex = expansionTileIndex;
        String serviceLocation = service.Area;
        if (service.SpecificLocation != "") {
          serviceLocation += ", " + service.SpecificLocation;
        }
        serviceLocation = serviceLocation.replaceAll("קומה -1", "קומה 1-");
        String serviceTitle;
        if (service.Type == "businesses") {
          BusinessService business = service;
          serviceTitle = business.Name;
        } else if (service.Type == "academicServices") {
          AcademicService academicService = service;
          serviceTitle = academicService.Name;
        } else {
          serviceTitle = service.Subtype;
        }
        return new Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(220, 250, 250, 0.9)),
            color: Color.fromRGBO(200, 230, 230, 0.7),
          ),
          child: ExpansionTile(
            initiallyExpanded: _isTileExpanded(currExpansionTileIndex),
            onExpansionChanged: (expanded) {
              if (expanded &&
                  servicesList.length > 4 &&
                  currExpansionTileIndex == servicesList.length) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent + 150);
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent + 800,
                    duration: Duration(milliseconds: 3000),
                    curve: Curves.ease);
              }
            },
            title: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _mapServicesToIcons[service.Subtype],
                      Text(
                        serviceTitle,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 20,
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
            backgroundColor: Color.fromRGBO(200, 240, 255, 0.8),
            children: expansionTileContent(service, currExpansionTileIndex),
          ),
        );
      }).toList()),
    );
  }

  bool _isTileExpanded(int tileIndex) {
    if (widget.model.SelectedServiceIndex == tileIndex) {
      return true;
    } else {
      return false;
    }
  }

  List<Widget> expansionTileContent(
      Service service, int currExpansionTileIndex) {
    switch (service.Type) {
      case "machines":
        {
          return machinesContent(service, currExpansionTileIndex);
        }
        break;

      case "welfare":
        {
          return welfareContent(service);
        }
        break;

      case "businesses":
        {
          return businessesContent(service);
        }
        break;

      case "academicServices":
        {
          return academicServicesContent(service);
        }
        break;

      case "prayerServices":
        {
          return prayerServicesContent(service);
        }
        break;

      case "computersLabs":
        {
          return computersLabsContent(service);
        }
        break;

      case "securityServices":
        {
          return securityServicesContent(service);
        }
        break;

      default:
        {
          return <Widget>[];
        }
        break;
    }
  }

  List<Widget> machinesContent(Service service, int currExpansionTileIndex) {
    Widget milkInfo;
    if (service.Subtype == "מקרר") {
      milkInfo = _milkUI(service, currExpansionTileIndex);
    } else {
      milkInfo = Row();
    }
    return <Widget>[
      _availabilityUI(service, currExpansionTileIndex),
      milkInfo,
    ];
  }

  Widget _milkUI(MachineService service, int currExpansionTileIndex) {
    RefrigeratorService refrigerator = service;
    Widget milkInfo;
    Widget milkText;
    Widget milkIcon;
    Widget milkReportButton;
    Widget milkReportText;
    if (refrigerator.Availability == false) {
      return Row();
    }
    if (refrigerator.Milk == true) {
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
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: milkReportText,
            onPressed: () {
              setState(() {
                bool updatedMilkAvailability;
                if (refrigerator.Milk == true) {
                  updatedMilkAvailability = false;
                } else {
                  updatedMilkAvailability = true;
                }
                _connectionMode == ConnectionMode.RegisteredUser
                    ? _registeredUserMilkReport(refrigerator,
                        updatedMilkAvailability, currExpansionTileIndex)
                    : _guestUserMilkReport();
              });
            },
          ),
        ],
      ),
    );

    milkInfo = Container(
      width: 140,
      padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
      child: Row(
        children: <Widget>[milkIcon, milkText],
      ),
    );
    return Column(
      children: <Widget>[
        Row(children: <Widget>[milkInfo, milkReportButton]),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 10),
          child: Row(
            children: <Widget>[
              Icon(MaterialCommunityIcons.file_document_edit_outline),
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

  void _registeredUserMilkReport(RefrigeratorService refrigerator,
      bool updatedMilkAvailability, int currExpansionTileIndex) {
    String alertText = "";
    if (updatedMilkAvailability == false) {
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
                    widget.model.refrigeratorReport(
                        refrigerator, true, updatedMilkAvailability);
                    widget.model.SelectedServiceIndex = currExpansionTileIndex;
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

  Widget _availabilityUI(MachineService service, int currExpansionTileIndex) {
    Widget availabilityInfo;
    Widget availabilityIcon;
    Widget availabilityText;
    Widget availabilityReportButton;
    Widget availabilityReportText;
    if (service.Availability == false) {
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
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: availabilityReportText,
            onPressed: () {
              setState(() {
                _connectionMode == ConnectionMode.RegisteredUser
                    ? _registeredUserAvailabilityReport(
                        service, currExpansionTileIndex)
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
          padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
          child: Row(
            children: <Widget>[
              Icon(MaterialCommunityIcons.file_document_edit_outline),
              Text("דווח לאחרונה: " + service.AvailabilityReportDate)
            ],
          ),
        )
      ],
    );
  }

  void _registeredUserAvailabilityReport(
      MachineService service, int currExpansionTileIndex) {
    String alertText = "";
    if (service.Availability == false) {
      alertText = "השירות יוצג כפעיל";
    } else {
      alertText = "השירות יוצג כלא פעיל";
    }
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          bool updatedAvailability;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('דיווח על זמינות השירות'),
              content: Text(alertText),
              actions: <Widget>[
                FlatButton(
                  child: Text('אישור'),
                  onPressed: () {
                    if (service.Availability == false) {
                      updatedAvailability = true;
                    } else {
                      updatedAvailability = false;
                    }
                    if (service.Subtype == "מקרר") {
                      Navigator.of(context).pop();
                      setState(() {
                        _registeredUserRefrigeratorReport(service,
                            updatedAvailability, currExpansionTileIndex);
                      });
                    } else {
                      setState(() {
                        widget.model
                            .availabiltyReport(service, updatedAvailability);
                        widget.model.SelectedServiceIndex =
                            currExpansionTileIndex;
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

  void _registeredUserRefrigeratorReport(MachineService service,
      bool updatedAvailability, currExpansionTileIndex) {
    if (updatedAvailability == true) {
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
                      widget.model.refrigeratorReport(
                          refrigeratorReport, updatedAvailability, true);
                      widget.model.SelectedServiceIndex =
                          currExpansionTileIndex;
                      Navigator.of(context).pop();
                    });
                  },
                ),
                FlatButton(
                  child: Text('לא'),
                  onPressed: () {
                    setState(() {
                      widget.model.refrigeratorReport(
                          service, updatedAvailability, false);
                      widget.model.SelectedServiceIndex =
                          currExpansionTileIndex;
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
        widget.model.refrigeratorReport(service, updatedAvailability, false);
      });
    }
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

  Widget _locationSearch() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        color: Color.fromRGBO(255, 255, 255, 0.9),
      ),
      height: 50,
      width: 350,
      margin: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAutoCompleteTextField(),
          Container(
            width: 45,
            height: 45,
            child: IgnorePointer(
              ignoring: _isNotPressable,
              child: RaisedButton(
                  color: _buttonColor,
                  shape: CircleBorder(),
                  child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialIcons.search,
                        size: 30,
                        color: Colors.white,
                      )),
                  onPressed: () {
                    setState(() {
                      _searchPress();
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAutoCompleteTextField() {
    return Container(
      width: 240,
      child: _textField = AutoCompleteTextField<String>(
        key: _key,
        clearOnSubmit: false,
        focusNode: _focusNode,
        suggestions: (widget.model.Locations).map((location) {
          return location.Number + " - " + location.Name;
        }).toList(),
        suggestionsAmount: 12,
        style: TextStyle(color: Colors.black, fontSize: 18.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          hintText: 'חיפוש מיקום באוניברסיטה',
        ),
        itemFilter: (area, query) {
          List<String> splitArea = area.split(" ");
          for (int i = 0; i < splitArea.length; i++) {
            if (area.startsWith(query) ||
                (splitArea[i] != "-" && splitArea[i].startsWith(query)) ||
                query == "") {
              return true;
            }
          }
          return false;
        },
        itemSorter: (area1, area2) {
          int result = area1.length.compareTo(area2.length);
          if (result != 0) {
            return result;
          } else {
            return area1.compareTo(area2);
          }
        },
        itemSubmitted: (area) {
          setState(() {
            //FocusScope.of(context).requestFocus(new FocusNode());
            _isSearchPressed = false;
            _title = Container();
            _selectedArea = area;
            _textField.textField.controller.text = _selectedArea;
            _isNotPressable = false;
            _buttonColor = Colors.blue;
          });
        },
        textChanged: (area) {
          _isSearchPressed = false;
          _title = Container();
          _selectedArea = area;
          widget.model.SelectedServiceIndex = 0;
          if (widget.model.Areas.contains(_selectedArea)) {
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
        itemBuilder: (context, area) {
          // UI for the autocomplete row
          return Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('$area'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _searchPress() {
    //widget.model.addPrayerService();
    FocusScope.of(context).requestFocus(new FocusNode());
    _title = Container(
      width: 600,
      height: 50,
      color: Color.fromRGBO(200, 230, 230, 1),
      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Text(
        "השירותים באזור " + _selectedArea + ":",
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
    _isSearchPressed = true;
    _textField.textField.controller.text = "";
    _buttonColor = Colors.grey;
    if (_selectedArea != null) {
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

  Map<String, AssetImage> _mapServicesToImages() {
    Map<String, AssetImage> servicesToImages = {
      "בתי קפה ומסעדות": AssetImage("assets/resturants_and_coffee_shops.jpg"),
      "חנויות ועסקים": AssetImage("assets/shops_and_businesses.jpg"),
      "מכונות חטיפים": AssetImage("assets/snack_machines.jpg"),
      "מזכירויות ומנהלה":
          AssetImage("assets/secretaries_and_administration.jpg"),
      "ספריות": AssetImage("assets/libraries.jpg"),
      "חדרי הנקה": AssetImage("assets/nursing_rooms.jpg"),
      "חדרי רווחה": AssetImage("assets/welfare_rooms.jpg"),
      "פינות קפה": AssetImage("assets/coffee_corners.jpg"),
      "מים חמים": AssetImage("assets/hot_water.jpg"),
      "מקררים": AssetImage("assets/refrigerators.jpg"),
      "מיקרוגלים": AssetImage("assets/microwaves.jpg"),
      "מכונות שתייה": AssetImage("assets/drink_machines.jpg"),
      "מעבדות מחשבים": AssetImage("assets/computers_labs.jpg"),
      "מניינים": AssetImage("assets/minyanim.jpg"),
      "שערים ואבטחה": AssetImage("assets/gates_and_security.jpg"),
      "מכשירי החייאה": AssetImage("assets/defibrillators.jpg"),
      "שירותי צילום והדפסה": AssetImage("assets/copy_and_print_services.jpg"),
      "קולרים": AssetImage("assets/faucets.jpg"),
    };
    return servicesToImages;
  }

  Widget _buildSpecificServiceTypePage(
      String serviceType, List<Service> services) {
    Map<String, AssetImage> servicesToImages = _mapServicesToImages();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          top: 110,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _showServicesByType(serviceType, services),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: servicesToImages[serviceType],
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.55),
              BlendMode.dstATop,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showServicesByType(
      String specificServiceType, List<Service> services) {
    List<Service> servicesByType = [];
    List<String> servicesTypes = [""];
    if (specificServiceType == "חנויות ועסקים") {
      for (int i = 0; i < services.length; i++) {
        if ((services[i].Type) == "businesses" &&
            services[i].Subtype != "בית קפה" &&
            services[i].Subtype != "מסעדה") {
          servicesByType.add(services[i]);
        }
      }
    } else if (specificServiceType == "פינות קפה") {
      for (int i = 0; i < services.length; i++) {
        if (services[i].SpecificLocation.contains("פינת קפה")) {
          servicesByType.add(services[i]);
        }
      }
    } else if (specificServiceType == "חדרי רווחה") {
      for (int i = 0; i < services.length; i++) {
        if (services[i].Subtype == "חדר רווחה" ||
            services[i].SpecificLocation.contains("חדר רווחה")) {
          servicesByType.add(services[i]);
        }
      }
    } else if (specificServiceType == "חדרי הנקה") {
      for (int i = 0; i < services.length; i++) {
        if (services[i].Subtype == "חדר הנקה" ||
            services[i].SpecificLocation.contains("חדר הנקה")) {
          servicesByType.add(services[i]);
        }
      }
    } else {
      switch (specificServiceType) {
        case "בתי קפה ומסעדות":
          servicesTypes.add("בית קפה");
          servicesTypes.add("מסעדה");
          break;
        case "מזכירויות והנהלה":
          servicesTypes.add("מזכירות");
          break;
        case "ספריות":
          servicesTypes.add("ספריה");
          break;
        case "מים חמים":
          servicesTypes.add("מים חמים");
          break;
        case "מקררים":
          servicesTypes.add("מקרר");
          break;
        case "מיקרוגלים":
          servicesTypes.add("מיקרוגל בשרי");
          servicesTypes.add("מיקרוגל חלבי");
          break;
        case "מכונות חטיפים":
          servicesTypes.add("מכונת חטיפים");
          break;
        case "מכונות שתייה":
          servicesTypes.add("מכונת שתייה");
          break;
        case "מעבדות מחשבים":
          servicesTypes.add("מעבדת מחשבים");
          break;
        case "מניינים":
          servicesTypes.add("מניין");
          break;
        case "שערים ואבטחה":
          servicesTypes.add("שירותי אבטחה");
          break;
        case "מכשירי החייאה":
          servicesTypes.add("מכשיר החייאה (דפיברילטור)");
          break;
        case "שירותי צילום והדפסה":
          servicesTypes.add("מכונת צילום והדפסה");
          break;
        case "קולרים":
          servicesTypes.add("קולר");
          break;
      }
    }
    for (int i = 0; i < services.length; i++) {
      servicesTypes.forEach((type) {
        if (type == (services[i].Subtype)) {
          servicesByType.add(services[i]);
        }
      });
    }
    return ListView(children: <Widget>[_createServicesList(servicesByType)]);
  }
}
