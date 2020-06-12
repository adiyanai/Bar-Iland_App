import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import '../scoped-models/main.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              height: height * 0.7,
              width: width,
              child: PhotoView(
                imageProvider: AssetImage('assets/shuttles_map.png'),
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
                      child: TextField(
                        maxLines: 1,
                        key: _textFieldKey,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'הכנס מס\' תחנה...',
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
                          } else if (int.parse(value) > 0 &&
                              int.parse(value) < 17) {
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
                          if (value.isEmpty) {
                            setState(() {
                               _canPress = false;
                            });
                          } else if (int.parse(value) > 0 &&
                              int.parse(value) < 17) {
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
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      height: 35,
                      width: 82,
                      // navigation button
                      child: RaisedButton(
                        color: _canPress ? Colors.blue : Colors.grey[400],
                        child: Row(
                          children: <Widget>[
                            Text(
                              'ניווט',
                              style: TextStyle(
                                color: _canPress ? Colors.white : Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.near_me,
                              color: _canPress ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_canPress) {
                            LocationData userLocation =
                                await _location.getLocation();
                            /*String url =
                          'https://www.google.com/maps/dir/?api=1&origin=' +
                              userLocation.latitude.toString() +
                              ',' +
                              userLocation.longitude.toString() +
                              '&destination=' +
                              stationData.Lat +
                              ',' +
                              stationData.Lon +
                              '&travelmode=walking';
                      _launchURL(url);*/
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7),
                ),
                // shuttle timetable button
                child: IconButton(
                  icon: Icon(Icons.access_time),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/shuttleTimetable');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
