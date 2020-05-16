import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  final LocationData _locationData;

  GMap(this._locationData);

  @override
  State<StatefulWidget> createState() {
    return _GMapState();
  }
}

class _GMapState extends State<GMap> {
  @override
  void initState() {
    print(widget._locationData.latitude);
    print(widget._locationData.longitude);
    super.initState();
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
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget._locationData.latitude,
                    widget._locationData.longitude),
                zoom: 12,
              ),
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
