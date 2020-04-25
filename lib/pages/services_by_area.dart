import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bar_iland_app/models/connection.dart';
import 'package:bar_iland_app/services_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/service.dart';
import '../scoped-models/main.dart';

class ServicesByArea extends StatefulWidget {
  final MainModel model;
  ServicesByArea(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ServicesByAreaState();
  }
}

class _ServicesByAreaState extends State<ServicesByArea> {
  AutoCompleteTextField<String> _textField;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  final FocusNode _focusNode = FocusNode();
  String _selectedArea = "";
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
      MachineService service, bool updatedAvailability) {
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
                      widget.model.refrigeratorReport(_selectedArea,
                          refrigeratorReport, updatedAvailability, true);
                      Navigator.of(context).pop();
                    });
                  },
                ),
                FlatButton(
                  child: Text('לא'),
                  onPressed: () {
                    setState(() {
                      widget.model.refrigeratorReport(
                          _selectedArea, service, updatedAvailability, false);
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
            _selectedArea, service, updatedAvailability, false);
      });
    }
  }

  void _registeredUserAvailabilityReport(MachineService service) {
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
                        _registeredUserRefrigeratorReport(
                            service, updatedAvailability);
                      });
                    } else {
                      setState(() {
                        widget.model.availabiltyReport(
                            _selectedArea, service, updatedAvailability);
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
      RefrigeratorService refrigerator, bool updatedMilkAvailability) {
    String alertText = "";
    if (updatedMilkAvailability == FractionalOffsetTween) {
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
                    widget.model.refrigeratorReport(_selectedArea, refrigerator,
                        true, updatedMilkAvailability);
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
    //widget.model.addMachineService();
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
    _isOkPressed = true;
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
            _isOkPressed = false;
            _title = Container();
            _selectedArea = area;
            _textField.textField.controller.text = _selectedArea;
            _isNotPressable = false;
            _buttonColor = Colors.blue;
          });
        },
        textChanged: (area) {
          _isOkPressed = false;
          _title = Container();
          _selectedArea = area;
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
          /*
          Text(
            'מספר בניין:',
            style: TextStyle(fontSize: 20),
          ),
          */
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
                      _showPress();
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }

  Map<String, Icon> mapToIcons() {
    Map<String, Icon> servicesIcons = {
      "חדר רווחה": Icon(ServicesIcons.armchair, size: 20),
      "חדר הנקה": Icon(MaterialCommunityIcons.baby_bottle_outline),
      "מקרר": Icon(Icons.kitchen),
      "מכונת קפה": Icon(MdiIcons.coffeeMaker),
      "מיקרוגל חלבי": Icon(MdiIcons.microwave),
      "מיקרוגל בשרי": Icon(MdiIcons.microwave),
      "מים חמים": Icon(MdiIcons.kettleSteam),
      "מכונת חטיפים": Icon(MdiIcons.cookie),
      "מכונת שתייה": Icon(MdiIcons.bottleSodaClassicOutline),
      "מכונת צילום והדפסה": Icon(MdiIcons.printer),
      "פינות ישיבה ושולחנות": Icon(MaterialCommunityIcons.sofa),
      "נדנדה": Icon(ServicesIcons.swing),
      "מטבחון": Icon(MaterialCommunityIcons.water_pump),
      "משטחי החתלה": Icon(MdiIcons.humanBabyChangingTable),
      "בית קפה": Icon(MaterialCommunityIcons.coffee),
      "מסעדה": Icon(MaterialIcons.restaurant),
      "בנק": Icon(MaterialCommunityIcons.bank),
      "דואר": Icon(MaterialCommunityIcons.mailbox),
      "ציוד משרדי וכלי כתיבה": Icon(MaterialCommunityIcons.pencil),
      "סופר": Icon(MaterialCommunityIcons.cart),
      "חנות בגדים": Icon(MaterialCommunityIcons.shopping),
      "סנדלריה": Icon(MdiIcons.tools),
      "סוכנות נסיעות": Icon(MdiIcons.airplane),
      "ספריה": Icon(MdiIcons.library),
      "מזכירות": Icon(MdiIcons.officeBuilding),
      "מנייני ערבית": Icon(MaterialCommunityIcons.book_open_page_variant),
      "שעות פעילות": Icon(MaterialCommunityIcons.clock_outline),
      "טלפון": Icon(MdiIcons.phone),
      "מידע נוסף": Icon(MaterialCommunityIcons.information_outline),
      "מייל": Icon(MaterialCommunityIcons.email_box),
      "אתר": Icon(MaterialCommunityIcons.web),
      "מנייני שחרית": Icon(MaterialCommunityIcons.book_open_page_variant),
      "מנייני מנחה": Icon(MaterialCommunityIcons.book_open_page_variant),
      "זמני תפילות שעון קיץ":
          Icon(MaterialCommunityIcons.clock_outline, size: 0),
      "זמני תפילות שעון חורף":
          Icon(MaterialCommunityIcons.clock_outline, size: 0),
      "שעון קיץ": Icon(MaterialCommunityIcons.clock_outline),
      "שעון חורף": Icon(MaterialCommunityIcons.clock_outline),
      "עזרת נשים": Icon(FontAwesome.female, size: 18),
      "מעבדת מחשבים": Icon(Icons.computer),
      "מכשיר החייאה (דפיברילטור)": Icon(MdiIcons.medicalBag),
    };
    return servicesIcons;
  }

  Widget _milkUI(MachineService service) {
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

  List<Widget> machinesContent(Service service) {
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
  }

  List<Widget> welfareContent(Service service) {
    WelfareService welfareRoom = service;
    return [
      ...welfareRoom.Contains.map((containedService) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
          child: Row(children: [
            mapToIcons()[containedService],
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
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchCaller(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMail(String mail) async {
    String url = "mailto:$mail";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> businessesContent(Service service) {
    BusinessService business = service;
    Map<String, Widget> businessInfo = Map<String, Widget>();
    if (business.ActivityTime != "") {
      businessInfo["שעות פעילות"] = Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(business.ActivityTime));
    }
    if (business.PhoneNumber != "") {
      businessInfo["טלפון"] = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: GestureDetector(
          onTap: () {
            _launchCaller(business.PhoneNumber);
          },
          child: Text(
            business.PhoneNumber,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      );
    }
    if (business.GeneralInfo != "") {
      businessInfo["מידע נוסף"] = Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(business.GeneralInfo));
    }
    return (businessInfo.keys).map((infoType) {
      return Container(
        width: 320,
        padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          mapToIcons()[infoType],
          Expanded(child: businessInfo[infoType])
        ]),
      );
    }).toList();
  }

  List<Widget> academicServicesContent(Service service) {
    AcademicService academicService = service;
    Map<String, Widget> academicServiceInfo = {
      "שעות פעילות": Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(academicService.ActivityTime)),
      "טלפון": Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: GestureDetector(
          onTap: () {
            _launchCaller(academicService.PhoneNumber);
          },
          child: Text(
            academicService.PhoneNumber,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ),
      "מייל": Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: GestureDetector(
          onTap: () {
            _launchMail(academicService.Mail);
          },
          child: Text(
            academicService.Mail,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ),
      "אתר": Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: GestureDetector(
          onTap: () {
            _launchURL(academicService.Website);
          },
          child: Text(
            academicService.Website,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ),
    };
    return (academicServiceInfo.keys).map((infoType) {
      return Container(
        width: 320,
        padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          mapToIcons()[infoType],
          Expanded(child: academicServiceInfo[infoType])
        ]),
      );
    }).toList();
  }

  List<Widget> prayerServicesContent(Service service) {
    PrayerService prayerService = service;
    Map<String, Container> prayerServiceInfo = Map<String, Container>();
    String clock;
    if (prayerService.WinterPrayers != "") {
      clock = "שעון חורף";
      prayerServiceInfo[clock] = Container(
        child: Text("שעון חורף",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.underline,
            )),
      );
      prayerServiceInfo["זמני תפילות שעון חורף"] = Container(
          padding: EdgeInsets.only(right: 20),
          child: Text(prayerService.WinterPrayers));
    }
    if (prayerService.SummerPrayers != "") {
      clock = "שעון קיץ";
      prayerServiceInfo[clock] = Container(
          child: Text(
        "שעון קיץ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ));
      prayerServiceInfo["זמני תפילות שעון קיץ"] = Container(
          padding: EdgeInsets.only(right: 20),
          child: Text(prayerService.SummerPrayers));
    }
    if (prayerService.WomanSection != "") {
      prayerServiceInfo["עזרת נשים"] =
          Container(child: Text(prayerService.WomanSection));
    }
    return [
      Container(
        child: Column(
            children: (prayerServiceInfo.keys).map((info) {
          return Container(
            padding: EdgeInsets.only(right: 15),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [mapToIcons()[info], prayerServiceInfo[info]]),
          );
        }).toList()),
      )
    ];
  }

  List<Widget> computersLabsContent(service) {
    ComputersLabService computersLab = service;
    Map<String, String> computersLabInfo = Map<String, String>();
    computersLabInfo["שעות פעילות"] = computersLab.ActivityTime;
    return [
      Container(
        child: Column(
            children: (computersLabInfo.keys).map((info) {
          return Container(
            padding: EdgeInsets.only(right: 15),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [mapToIcons()[info], Text(computersLabInfo[info])]),
          );
        }).toList()),
      )
    ];
  }

  List<Widget> expansionTileContent(Service service) {
    if (service.Type == "machines") {
      return machinesContent(service);
    } else if (service.Type == "welfare") {
      return welfareContent(service);
    } else if (service.Type == "businesses") {
      return businessesContent(service);
    } else if (service.Type == "academicServices") {
      return academicServicesContent(service);
    } else if (service.Type == "prayerServices") {
      return prayerServicesContent(service);
    } else if (service.Type == "computersLabs") {
      return computersLabsContent(service);
    }
    return <Widget>[];
  }

  Widget _showServices(String area, List<Service> services) {
    //widget.model.addAcademicService();
    List<Service> servicesInArea = [];
    for (int i = 0; i < services.length; i++) {
      if (area.contains(services[i].Area)) {
        servicesInArea.add(services[i]);
      }
    }
    if (!_isOkPressed) {
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
          child: Text('לא נמצאו שירותים באזור זה',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Column(
          children: servicesInArea.map((service) {
        String serviceLocation = service.Area;
        if (service.SpecificLocation != "") {
          serviceLocation += ", " + service.SpecificLocation;
        }
        serviceLocation = serviceLocation.replaceAll("קומה -1", "קומה 1-");
        Map<String, Icon> servicesToIcons = mapToIcons();
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
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      servicesToIcons[service.Subtype],
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
            children: expansionTileContent(service),
          ),
        );
      }).toList()),
    );
  }

  Widget _buildPage(List<Service> services) {
    //FocusScope.of(context).autofocus(_focusNode);
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
          child: ListView(
            children: <Widget>[
              _displayedServices = _showServices(
                _selectedArea,
                services,
              )
            ],
          ),
        ),
        _title,

        //_addingButton,
        _locationSearch(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content;
        if (!model.isServicesLoading) {
          content = _buildPage(model.services);
        } else if (model.isServicesLoading) {
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
