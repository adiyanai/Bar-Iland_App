import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/shuttle_station.dart';

class Shuttles extends StatefulWidget {
  final MainModel model;
  Shuttles(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ShuttlesState();
  }
}

class _ShuttlesState extends State<Shuttles> {
  final GlobalKey<FormState> _textFieldKey = GlobalKey<FormState>();
  bool _canPress;
  Location _location;
  String _selStation;

  @override
  void initState() {
    _canPress = false;
    _location = new Location();
    _selStation = '';
    super.initState();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  IconButton _createNavigationButton() {
    return IconButton(
      padding: EdgeInsets.all(5),
      icon: Icon(
        Icons.near_me,
        color: _canPress ? Colors.white : Colors.black,
      ),
      onPressed: () async {
        if (_canPress) {
          LocationData userLocation = await _location.getLocation();
          List<ShuttleStation> stations = widget.model.allShuttleStations;
          String stationLat, stationLon;
          // find the _selStation data
          for (ShuttleStation station in stations) {
            if (station.Number == _selStation) {
              stationLat = station.Lat;
              stationLon = station.Lon;
              break;
            }
          }

          String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
              userLocation.latitude.toString() +
              ',' +
              userLocation.longitude.toString() +
              '&destination=' +
              stationLat +
              ',' +
              stationLon +
              '&travelmode=walking';
          _launchURL(url);
        }
      },
    );
  }

  TextField _createStationNumberTextField() {
    return TextField(
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      maxLines: 1,
      key: _textFieldKey,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'הכנס/י מס\' תחנה',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        filled: true,
        fillColor: Colors.white60,
      ),
      onSubmitted: (String value) {
        if (value.isEmpty) {
          setState(() {
            _canPress = false;
          });
        } else if (int.parse(value) > 0 && int.parse(value) < 17) {
          setState(() {
            _canPress = true;
            _selStation = value;
          });
        } else {
          setState(() {
            _canPress = false;
          });
        }
      },
      onChanged: (String value) {
        if (value.length > 2) {
          return;
        }
        if (value.isEmpty) {
          setState(() {
            _canPress = false;
          });
        } else if (int.parse(value) > 0 && int.parse(value) < 17) {
          setState(() {
            _canPress = true;
            _selStation = value;
          });
        } else {
          setState(() {
            _canPress = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return model.isShuttleStationsLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      // background map image
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: height * 0.7,
                          width: width,
                          child: PhotoView(
                            imageProvider:
                                AssetImage('assets/shuttles_map.png'),
                            backgroundDecoration:
                                BoxDecoration(color: Colors.white),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 4.8,
                            initialScale: PhotoViewComputedScale.contained,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  width: 150,
                                  // Enter station number TextField
                                  child: _createStationNumberTextField(),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  height: 35,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: _canPress
                                        ? Colors.blue
                                        : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  // navigation button
                                  child: _createNavigationButton(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 105,
                            height: 35,
                            // shuttle timetable button
                            child: RaisedButton.icon(
                              color: Colors.lightBlue[300],
                              label: Text(
                                'לו\"ז יומי',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              icon: Icon(
                                Icons.departure_board,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/shuttleTimetable');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
