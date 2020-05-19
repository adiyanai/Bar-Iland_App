import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../models/event_location.dart';

class GMap extends StatefulWidget {
  final EventLocation _eventLocationData;

  GMap(this._eventLocationData);

  @override
  State<StatefulWidget> createState() {
    return _GMapState();
  }
}

class _GMapState extends State<GMap> {
  Location _location;
  LocationData _userLocation;
  GoogleMapController _controller;
  StreamSubscription _locationSubscription;
  Set<Marker> _markers = {};
  Set<Polyline> _polyline = {};
  List<LatLng> _routeCoords = [];
  PolylinePoints polylinePoints;
  String googleAPiKey = 'AIzaSyCwsFueaUv5CJKA-lGfFvbwSXFhwYKEOBk';
  double _userLat;
  double _userLon;

  @override
  void initState() {
    _location = Location();
    polylinePoints = PolylinePoints();
    _initUserLocation();
    super.initState();
  }

  void _initUserLocation() async {
    LocationData location = await _location.getLocation();
    setState(() {
      _userLocation = location;
      //_userLat = location.latitude;
      //_userLon = location.longitude;
    });
  }

  void _addPolyLine() {
    setState(() {
      _polyline.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: _routeCoords,
          color: Colors.blue,
          width: 5,
          geodesic: true));
    });
  }

  void _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_userLocation.latitude, _userLocation.longitude),
      PointLatLng(widget._eventLocationData.Lat, widget._eventLocationData.Lon),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      setState(() {
        result.points.forEach((PointLatLng point) {
          _routeCoords.add(LatLng(point.latitude, point.longitude));
        });
      });
    }
    _addPolyLine();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  void getCurrentLocation() async {
    try {
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _location.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller
              .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(newLocalData.latitude, newLocalData.longitude),
            tilt: 0,
            zoom: 16.00,
          )));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('מפה'),
        ),
        body: Stack(
          children: <Widget>[
            _userLocation == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          _userLocation.latitude, _userLocation.longitude),
                      zoom: 16,
                    ),
                    markers: _markers,
                    polylines: _polyline,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        _controller = controller;
                        getCurrentLocation();
                        _markers.add(Marker(
                          markerId: MarkerId("eventLocation"),
                          position: LatLng(widget._eventLocationData.Lat,
                              widget._eventLocationData.Lon),
                          draggable: false,
                          zIndex: 2,
                        ));
                        _getPolyline();
                        /*_routeCoords.add(LatLng(
                            _userLocation.latitude, _userLocation.longitude));
                        _routeCoords.add(LatLng(widget._eventLocationData.Lat,
                            widget._eventLocationData.Lon));
                        _polyline.add(Polyline(
                            polylineId: PolylineId('route1'),
                            visible: true,
                            points: _routeCoords,
                            color: Colors.blue,
                            width: 5,
                            geodesic: true));*/
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
