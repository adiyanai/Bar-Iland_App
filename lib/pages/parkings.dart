import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class Parkings extends StatefulWidget {
  final MainModel model;
  Parkings(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ParkingsState();
  }
}

class _ParkingsState extends State<Parkings> {
  Location _location;

  @override
  void initState() {
    super.initState();
    widget.model.fetchParkings();
    _location = new Location();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/parkings.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: widget.model.Parkings.map((parking) {
            return Column(children: [
              SizedBox(height: 40),
              Container(
                width: 400,
                color: Color.fromRGBO(180, 230, 240, 0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0,
                      child: Icon(
                        FontAwesome5Solid.parking,
                        color: Color.fromRGBO(0, 0, 220, 1),
                      ),
                    ),
                    Text(
                      parking.Name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.near_me,
                        size: 28,
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        LocationData userLocation =
                            await _location.getLocation();
                        String url =
                            'https://www.google.com/maps/dir/?api=1&origin=' +
                                userLocation.latitude.toString() +
                                ',' +
                                userLocation.longitude.toString() +
                                '&destination=' +
                                parking.Lat +
                                ',' +
                                parking.Lon +
                                '&travelmode=driving';
                        _launchURL(url);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: 400,
                color: Color.fromRGBO(190, 230, 250, 0.5),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(MaterialIcons.location_on),
                        Container(
                          child: Expanded(
                            child: Text(
                              parking.Location,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(MaterialCommunityIcons.coin),
                        Container(
                          child: Expanded(
                            child: Text(
                              parking.Price,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(MaterialCommunityIcons.gate),
                        Container(
                          child: Expanded(
                            child: Text(
                              "שער קרוב ביותר: " + parking.ClosestGate,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20)
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
