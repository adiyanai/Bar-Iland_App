import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:bar_iland_app/models/service.dart';
import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:bar_iland_app/models/connection.dart';
import 'package:bar_iland_app/models/bar_ilan_location.dart';
import 'package:bar_iland_app/utilities/services_icons.dart';
import 'package:bar_iland_app/widgets/services_widgets.dart';

class Services extends StatefulWidget {
  final MainModel model;
  final String servicesView;
  Services(this.model, this.servicesView);

  @override
  State<StatefulWidget> createState() {
    return _ServicesState();
  }
}

class _ServicesState extends State<Services> {
  String _servicesView;
  ConnectionMode _connectionMode;
  Future<List<Service>> _servicesList;
  Widget _displayedServicesByArea = Column();
  Widget _servicesListView;
  Map<String, Icon> _mapServicesToIcons;
  AutoCompleteTextField<String> _textField;
  Widget _title = Container();
  ScrollController _scrollController;
  ScrollController _servicesButtonsScrollController = ScrollController();
  GlobalKey<AutoCompleteTextFieldState<String>> _textFieldKey = new GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String _selectedArea = "";
  bool _isNotPressable = true;
  bool _isSearchPressed = false;
  Color _searchButtonColor = Colors.grey;
  String _sortingButtonText = "מיון מהקרוב לרחוק";
  Location _currentLocation = new Location();
  String _sortingOrder = "Ascending";
  List<BarIlanLocation> _allServicesLocations = List<BarIlanLocation>();
  LocationData _userLocation;

  @override
  void initState() {
    super.initState();
    _servicesView = widget.servicesView;
    _connectionMode = widget.model.connectionMode;
    _mapServicesToIcons = mapToIcons();
    _allServicesLocations = widget.model.AllServicesLocations;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content;
        if (!model.isServicesLoading) {
          switch (_servicesView) {
            // build services by area page
            case "לפי מיקום":
              content = _buildServicesByAreaPage(model.services);
              break;
            // build the main page of services by type
            case "לפי סוג שירות":
              content = _buildServicesByTypePage();
              break;
            // build the page of the specific service
            default:
              content = _buildSpecificServiceByTypePage();
              break;
          }
        } else if (model.isServicesLoading) {
          switch (_servicesView) {
            // build services by location loading page
            case "לפי מיקום":
              content = Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("assets/Bar_Ilan_Mini_Map.jpg"),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.9), BlendMode.softLight),
                    ),
                  ),
                  child: Center(child: CircularProgressIndicator()));
              break;
            // build services by type loading page
            default:
              content = Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/services_by_type_background.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                  child: Center(child: CircularProgressIndicator()));
          }
        }
        return content;
      },
    );
  }

  // sort the services by geographical proximity to the current location of the user
  List<Service> _sortByGeographicalProximity(List<Service> servicesList) {
    _userLocation = widget.model.userLocation;
    servicesList.sort((service1, service2) {
      // find the locations of the services in the list of all services locations
      BarIlanLocation location1Data = _allServicesLocations
          .firstWhere((BarIlanLocation item) => (service1.Area == item.Number));
      BarIlanLocation location2Data = _allServicesLocations
          .firstWhere((BarIlanLocation item) => (service2.Area == item.Number));
      // sort the services by geographical proximity, using calculateDistance function
      return (calculateDistance(_userLocation.latitude, _userLocation.longitude,
              location1Data.Lat, location1Data.Lon))
          .compareTo((calculateDistance(_userLocation.latitude,
              _userLocation.longitude, location2Data.Lat, location2Data.Lon)));
    });
    return servicesList;
  }

  // calculate the distance between two coordinates by latitude and longitude
  double calculateDistance(lat1, lon1, lat2, lon2) {
    final Distance distance = new Distance();
    return distance(new LatLng(lat1, lon1), new LatLng(lat2, lon2));
  }

  // build the button of a specific service in the main page of services by type
  Widget serviceTypeButton(String text, Icon icon) {
    return SizedBox.fromSize(
      size: Size(95, 95),
      child: ClipOval(
        child: Material(
          color: Colors.lightBlue[200],
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pushNamed(context, '/' + text);
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

  // build the main page of services by type
  Widget _buildServicesByTypePage() {
    FocusScope.of(context).requestFocus(FocusNode());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/services_by_type_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),

        // build all the buttons of the specific services by type
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _servicesButtonsScrollController,
          child: ListView(
            controller: _servicesButtonsScrollController,
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

  // build the page of the specific service
  Widget _buildSpecificServiceByTypePage() {
    return WillPopScope(
      onWillPop: () {
        widget.model.SelectedServiceIndex = 0;
        Navigator.pop(context);
        _servicesView = "לפי סוג שירות";
        return Future.value(true);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              _servicesView,
            ),
          ),
          body: Stack(children: [
            Container(
              child: _buildSpecificServiceTypePage(
                  _servicesView, widget.model.services),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(200, 240, 245, 1),
                border: Border.all(
                    width: 2, color: Color.fromRGBO(220, 250, 250, 0.9)),
              ),
              margin: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 170,
                    // services sorting button
                    child: RaisedButton.icon(
                      icon: Icon(Icons.location_on),
                      textColor: Colors.white,
                      color: Colors.blue,
                      label: Text(_sortingButtonText),
                      onPressed: () {
                        setState(() {
                          if (_sortingButtonText == "מיון מהקרוב לרחוק") {
                            widget.model.getCurrentLocation();
                            if (widget.model.userLocation != null) {
                              _sortingOrder = "Geographic";
                              _sortingButtonText = "מיון בסדר עולה";
                            }
                          } else {
                            _sortingOrder = "Ascending";
                            _sortingButtonText = "מיון מהקרוב לרחוק";
                          }
                        });
                      },
                    ),
                  ),
                  /*
                  Container(
                    width: 150,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.add),
                      textColor: Colors.white,
                      color: Colors.blue,
                      label: Text("הוספת שירות"),
                      onPressed: () {},
                    ),
                  )
                  */
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // build services by area page
  Widget _buildServicesByAreaPage(List<Service> services) {
    _scrollController = ScrollController(
        initialScrollOffset: (widget.model.SelectedServiceIndex - 1) * 80.0);
    _servicesListView = Scrollbar(
      isAlwaysShown: false,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          _displayedServicesByArea = _showServicesByArea(
            (_selectedArea.split(" - "))[0],
            services,
          )
        ],
      ),
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
            padding: EdgeInsets.fromLTRB(0, 148, 0, 0),
            height: 600,
            child: _servicesListView),
        _title,
        //_addingButton,
        _locationSearch(),
      ],
    );
  }

  // display all the services in the specific area
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
    // if there are no services in the specific area, show a message that no services found
    if (servicesInArea.length == 0) {
      return Center(
        child: Container(
          width: 600,
          height: 150,
          color: Color.fromRGBO(200, 230, 230, 0.7),
          margin: EdgeInsets.fromLTRB(0, 44, 0, 0),
          padding: EdgeInsets.all(20),
          child: Text(
            'לא נמצאו שירותים במיקום זה.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    return _createServicesList(servicesInArea, "ServicesByArea");
  }

  // sort the services by ascending order of their areas
  void _sortInAscendingOrder(List<Service> servicesList) {
    servicesList.sort((service1, service2) {
      List<String> location1SplitNumber = service1.Area.split(" ");
      List<String> location2SplitNumber = service2.Area.split(" ");
      if (location1SplitNumber[0] != "שער" &&
          location2SplitNumber[0] != "שער") {
        return int.parse(location1SplitNumber[1])
            .compareTo(int.parse(location2SplitNumber[1]));
      } else {
        int result = location1SplitNumber[0].compareTo(location2SplitNumber[0]);
        if (result != 0) {
          return result;
        } else {
          return int.parse(location1SplitNumber[1])
              .compareTo(int.parse(location2SplitNumber[1]));
        }
      }
    });
  }

  // build a navigation button for services by type
  Widget _buildNavigationButton(
      String servicesBy, String selServiceLocationNumber) {
    SizedBox navigationButton = SizedBox();
    if (servicesBy == "ServicesByType") {
      navigationButton = SizedBox(
        width: 35,
        child: IconButton(
          icon: Icon(
            Icons.near_me,
            color: Colors.blue,
          ),
          onPressed: () async {
            // get the data of the location
            BarIlanLocation locationData = widget.model.AllServicesLocations
                .firstWhere((BarIlanLocation item) =>
                    (selServiceLocationNumber == item.Number));
            widget.model.getCurrentLocation();
            if (widget.model.userLocation != null) {
              LocationData userLocation = widget.model.userLocation;
              String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
                  userLocation.latitude.toString() +
                  ',' +
                  userLocation.longitude.toString() +
                  '&destination=' +
                  locationData.Lat.toString() +
                  ',' +
                  locationData.Lon.toString() +
                  '&travelmode=walking';
              _launchURL(url);
            }
          },
        ),
      );
    }
    return navigationButton;
  }

  // create a list of all the services - depending on the view of the services (by type or by area)
  Widget _createServicesList(List<Service> servicesList, String servicesBy) {
    // sort the services in the desired way (relevant to services by type)
    if (_sortingOrder == "Ascending") {
      _sortInAscendingOrder(servicesList);
    } else if (_sortingOrder == "Geographic") {
      servicesList = _sortByGeographicalProximity(servicesList);
    }
    int expansionTileIndex = 0;
    String selServiceLocationNumber = "";
    return Container(
      margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
      child: Column(
          children: servicesList.map((service) {
        expansionTileIndex += 1;
        int currExpansionTileIndex = expansionTileIndex;
        selServiceLocationNumber = service.Area;
        String serviceLocation = "";
        // if the service is not is the area but near it
        if (!service.IsInArea) {
          serviceLocation += "בסמוך ל";
        }
        serviceLocation += service.Area;
        if (service.SpecificLocation != "") {
          serviceLocation += ", " + service.SpecificLocation;
        }
        // fixing an issue in Hebrew UI
        serviceLocation = serviceLocation.replaceAll("קומה -1", "קומה 1-");
        String serviceTitle;
        // if the service is a business, show it's name instead of it's type
        if (service.Type == "businesses") {
          BusinessService business = service;
          serviceTitle = business.Name;
          // if the service is an academic service, show it's name instead of it's type
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
            color: Color.fromRGBO(190, 230, 240, 0.7),
          ),
          child: ExpansionTile(
            initiallyExpanded: _isTileExpanded(currExpansionTileIndex),
            // if it's the last tile and there are more than 4 tiles, scroll down
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
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: [
                        Icon(
                          Icons.location_on,
                          size: 18,
                        ),
                        Text(
                          serviceLocation,
                          style: TextStyle(fontSize: 14),
                        )
                      ]),
                      _buildNavigationButton(
                          servicesBy, selServiceLocationNumber),
                    ],
                  ),
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

  // if the given tile index is equal to the selected service index, then the tile is expanded
  bool _isTileExpanded(int tileIndex) {
    if (widget.model.SelectedServiceIndex == tileIndex) {
      return true;
    } else {
      return false;
    }
  }

  // build the content of the expansion tile of the service depending on the service type
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

  // build the content of machines service expansion tile
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

  // build the UI of milk for refrigerators
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

  // milk availability report for registered users
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

  // milk availability report for guest users (that actually cannot report)
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

  // availability UI for machines service
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

  // machines availability report for registered users
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

  // refrigerators availability report for registered users
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

  // machines availability report for guest users (that actually cannot report)
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

  // location search for services by area
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
                  color: _searchButtonColor,
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

  // build AutoCompleteTextField for services by area
  Widget _buildAutoCompleteTextField() {
    List<String> suggestions = [];
    _allServicesLocations.forEach((location) {
      suggestions.add(location.Number + " - " + location.Name);
    });
    return Container(
      width: 240,
      child: _textField = AutoCompleteTextField<String>(
        key: _textFieldKey,
        clearOnSubmit: false,
        focusNode: _focusNode,
        suggestions: suggestions,
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
          return suggestions
              .indexOf(area1)
              .compareTo(suggestions.indexOf(area2));
        },
        itemSubmitted: (area) {
          setState(() {
            _isSearchPressed = false;
            _title = Container();
            _selectedArea = area;
            _textField.textField.controller.text = _selectedArea;
            _isNotPressable = false;
            _searchButtonColor = Colors.blue;
          });
        },
        textChanged: (area) {
          BarIlanLocation locationData = null;
          setState(() {
            _isSearchPressed = false;
            _title = Container();
            _selectedArea = area;
            widget.model.SelectedServiceIndex = 0;
          });
          try {
            locationData = widget.model.AllServicesLocations.firstWhere(
                (BarIlanLocation item) => (_selectedArea == item.Number));
            setState(() {
              _isNotPressable = false;
              _searchButtonColor = Colors.blue;
            });
          // if no such location is exist
          } catch (err) {
            setState(() {
              _isNotPressable = true;
              _searchButtonColor = Colors.grey;
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

  // show all the relevant services in the given location
  void _searchPress() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _title = Container(
      width: 600,
      height: 82,
      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
      margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(205, 240, 235, 1),
          border:
              Border.all(width: 2, color: Color.fromRGBO(220, 250, 250, 0.9))),
      child: Column(
        children: <Widget>[
          Text(
            _selectedArea + ":",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 110,
                height: 30,
                child: RaisedButton.icon(
                  icon: Icon(Icons.near_me),
                  textColor: Colors.white,
                  color: Colors.blue,
                  label: Text("ניווט"),
                  onPressed: () async {
                    // get the data of the location
                    BarIlanLocation locationData = widget
                        .model.AllServicesLocations
                        .firstWhere((BarIlanLocation item) =>
                            ((_selectedArea.split(" - "))[0] == item.Number));
                    LocationData userLocation =
                        await _currentLocation.getLocation();
                    String url =
                        'https://www.google.com/maps/dir/?api=1&origin=' +
                            userLocation.latitude.toString() +
                            ',' +
                            userLocation.longitude.toString() +
                            '&destination=' +
                            locationData.Lat.toString() +
                            ',' +
                            locationData.Lon.toString() +
                            '&travelmode=walking';
                    _launchURL(url);
                  },
                ),
              ),
              /*
              Container(
                width: 140,
                height: 30,
                child: RaisedButton.icon(
                  icon: Icon(Icons.add),
                  textColor: Colors.white,
                  color: Colors.blue,
                  label: Text("הוספת שירות"),
                  onPressed: () {},
                ),
              )
              */
            ],
          ),
        ],
      ),
    );
    _isSearchPressed = true;
    _textField.textField.controller.text = "";
    _searchButtonColor = Colors.grey;
  }

  // backgroud images for the specific services by type
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

  // build a specific service by type page
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

  // display all the services with the specified type
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
        case "מזכירויות ומנהלה":
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
          servicesTypes.add("מכשיר החייאה");
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
    _scrollController = ScrollController(
        initialScrollOffset: (widget.model.SelectedServiceIndex - 1) * 100.0);
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          _createServicesList(servicesByType, "ServicesByType")
        ],
      ),
    );
  }

  // launch the specified URL if it can be handled by some app installed on the device
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
