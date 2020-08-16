import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

import '../scoped-models/main.dart';
import '../models/bus.dart';
import '../models/station.dart';

class BusesByCity extends StatefulWidget {
  final MainModel model;
  BusesByCity(this.model);

  @override
  State<StatefulWidget> createState() {
    return _BusesByCityState();
  }
}

class _BusesByCityState extends State<BusesByCity> {
  ScrollController _scrollController;
  AutoCompleteTextField<String> _textField;
  GlobalKey<AutoCompleteTextFieldState<String>> _textFieldKey = new GlobalKey();
  final FocusNode _focusNode = new FocusNode();
  ListView _busesListView;
  bool _isNotPressable = true;
  bool _isSearchPressed;
  Color _searchButtonColor = Colors.grey;
  List<String> _allCities;
  List<Station> _allStations;
  String _selectedCity;
  Widget _title;
  Location _location;

  @override
  void initState() {
    _location = new Location();
    _scrollController =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: false);
    _isSearchPressed = false;
    _selectedCity = "";
    _title = Container();
    super.initState();
  }

  // create map that maps from station to the buses that belongs to her
  Map<String, List<Bus>> _createStationBusesMap(List<Bus> busesList) {
    final Map<String, List<Bus>> stationToBuses = {};
    // go over all the buses
    for (Bus bus in busesList) {
      // check to which station the bus belong
      for (Station station in _allStations) {
        if (station.Buses.contains(bus.Id)) {
          if (stationToBuses.containsKey(station.Number)) {
            stationToBuses[station.Number].add(bus);
          } else {
            stationToBuses[station.Number] = [bus];
          }
        }
      }
    }
    return stationToBuses;
  }

  // sort buses by number
  void _sortBusesByNumber(List<Bus> busesList) {
    busesList.sort((bus1, bus2) {
      int numberBus1, numberBus2;
      if (bus1.Number == '47א') {
        numberBus1 = 47;
      } else {
        numberBus1 = int.parse(bus1.Number);
      }
      if (bus2.Number == '47א') {
        numberBus2 = 47;
      } else {
        numberBus2 = int.parse(bus2.Number);
      }
      return numberBus1.compareTo(numberBus2);
    });
  }

  // launch url
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // build the List of all the relevant buses
  Widget _createBusesList(List<Bus> busesList) {
    // create map that maps from station to the buses that belongs to her
    Map<String, List<Bus>> stationBusesMap = _createStationBusesMap(busesList);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
      child: Column(
        children: (stationBusesMap.keys).map((station) {
          List<Bus> busesInStation = stationBusesMap[station];
          // sort buses by number
          _sortBusesByNumber(busesInStation);
          Station stationData;
          // find the station data by the station's number
          for (Station s in _allStations) {
            if (s.Number == station) {
              stationData = s;
              break;
            }
          }
          // buses UI
          List<Widget> busesUI = [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                right: 6,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(200, 240, 255, 0.8),
              ),
              child: ListTile(
                leading: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    image: DecorationImage(
                      image: AssetImage('assets/station_sign.png'),
                    ),
                  ),
                ),
                title: Text(
                  stationData.Number + ' - ' + stationData.Name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.near_me,
                    size: 30,
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    LocationData userLocation = await _location.getLocation();
                    String url =
                        'https://www.google.com/maps/dir/?api=1&origin=' +
                            userLocation.latitude.toString() +
                            ',' +
                            userLocation.longitude.toString() +
                            '&destination=' +
                            stationData.Lat +
                            ',' +
                            stationData.Lon +
                            '&travelmode=walking';
                    // launch url to Google Maps
                    _launchURL(url);
                  },
                ),
              ),
            ),
          ];
          return Column(
            children: List.from(busesUI)
              ..addAll(busesInStation.map((bus) {
                String busTitle = bus.Number;
                String busDirection = bus.Origin + '\u{2190}' + bus.Destination;
                return new Container(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromRGBO(220, 250, 250, 0.9)),
                    color: Color.fromRGBO(190, 230, 240, 0.7),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.directions_bus,
                            ),
                            Text(
                              busTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.road_variant,
                                  size: 18,
                                ),
                                Text(
                                  busDirection,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: <Widget>[
                            Image(
                                image: AssetImage('assets/moovit _icon.png'),
                                height: 20,
                                width: 20),
                            RichText(
                              text: TextSpan(
                                text: 'moovit',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                // launch url to moovit
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchURL(bus.MoovitUrl);
                                  },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()),
          );
        }).toList(),
      ),
    );
  }

  // build show buses by city
  Widget _showBusesByCity(String city, List<Bus> buses) {
    if (city == "") {
      return Column();
    }
    List<Bus> busesInCity = [];
    // check which bus go through this city
    for (int i = 0; i < buses.length; i++) {
      // check the origin & destination
      if (city == (buses[i].Origin) || city == (buses[i].Destination)) {
        busesInCity.add(buses[i]);
      } else if (!(buses[i].CitiesBetween).isEmpty) {
        // check in all the cities between
        List<String> citiesBetween = buses[i].CitiesBetween;
        for (int j = 0; j < citiesBetween.length; j++) {
          if (city == citiesBetween[j]) {
            busesInCity.add(buses[i]);
            break;
          }
        }
      }
    }
    // if the search button doesn't press
    if (!_isSearchPressed) {
      return Column();
    }
    // if the city the user picked doesn't has any buses
    if (busesInCity.length == 0) {
      return Center(
        child: Container(
          width: 600,
          height: 150,
          color: Color.fromRGBO(200, 230, 230, 0.7),
          margin: EdgeInsets.fromLTRB(0, 44, 0, 0),
          padding: EdgeInsets.all(20),
          child: Text(
            'לא נמצאו אוטובוסים לעיר זו',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    // build the List of all the relevant buses
    return _createBusesList(busesInCity);
  }

  // build AutoCompleteTextField for the city pick
  Widget _buildAutoCompleteTextField() {
    List<String> suggestions = [];
    _allCities.forEach((city) {
      suggestions.add(city);
    });
    return Container(
      width: 205,
      child: _textField = AutoCompleteTextField<String>(
        key: _textFieldKey,
        clearOnSubmit: false,
        focusNode: _focusNode,
        suggestions: suggestions,
        suggestionsAmount: 12,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          hintText: 'הכנס/י עיר למציאת קווים',
        ),
        itemFilter: (city, query) {
          if (city.startsWith(query) || query == "") {
            return true;
          }
          return false;
        },
        itemSorter: (city1, city2) {
          return suggestions
              .indexOf(city1)
              .compareTo(suggestions.indexOf(city2));
        },
        itemSubmitted: (city) {
          setState(() {
            _isSearchPressed = false;
            _title = Container();
            _selectedCity = city;
            _textField.textField.controller.text = _selectedCity;
            _isNotPressable = false;
            _searchButtonColor = Colors.blue;
          });
        },
        textChanged: (city) {
          _isSearchPressed = false;
          _title = Container();
          _selectedCity = city;
          if (_allCities.contains(_selectedCity)) {
            setState(() {
              _isNotPressable = false;
              _searchButtonColor = Colors.blue;
            });
          } else {
            setState(() {
              _isNotPressable = true;
              _searchButtonColor = Colors.grey;
            });
          }
        },
        itemBuilder: (context, city) {
          // UI for the autocomplete row
          return Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('$city'),
              ),
            ),
          );
        },
      ),
    );
  }

  // when pressed show all the relevant buses for the city the user picked
  void _searchPress() {
    // change the title to be the city the user picked
    _title = Container(
      width: 600,
      height: 50,
      margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(205, 240, 235, 1),
        border: Border.all(width: 2, color: Color.fromRGBO(220, 250, 250, 0.9)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _selectedCity + ":",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    _isSearchPressed = true;
    _textField.textField.controller.text = "";
    _searchButtonColor = Colors.grey;
  }

  // build the buses by city search option
  Widget _busesByCitySearch() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        color: Colors.yellow[50],
      ),
      height: 50,
      width: 310,
      margin: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // build AutoCompleteTextField for the city pick
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
                    ),
                  ),
                  // when pressed show all the relevant buses for the city the user picked
                  onPressed: () {
                    setState(() {
                      _searchPress();
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  // start build the page
  Widget _buildBusesByCityPage(List<Bus> buses) {
    // build the ListView of all the relevant buses if the user picked a city
    _busesListView = ListView(
      controller: _scrollController,
      children: <Widget>[
        _showBusesByCity(
          _selectedCity,
          buses,
        )
      ],
    );
    return Stack(
      children: <Widget>[
        Container(
          // build background image
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/buses.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.9), BlendMode.softLight),
            ),
          ),
          padding: EdgeInsets.fromLTRB(0, 148, 0, 0),
          height: 600,
          // build the buses ListView (empty if the user doesn't pick a city)
          child: Scrollbar(
            controller: _scrollController,
            child: _busesListView,
          ),
        ),
        // title - the name of the city that picked
        _title,
        // build the buses by city search option
        _busesByCitySearch(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content;
        // if finished loading all the data build the page
        if (!model.isBusesLoading || !model.isStationsLoading) {
          _allCities = model.busesLocations;
          _allStations = model.allStations;
          content = _buildBusesByCityPage(model.allBuses);
        // else, show meanwhile a CircularProgressIndicator
        } else if (model.isBusesLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return content;
      },
    );

  }
}
