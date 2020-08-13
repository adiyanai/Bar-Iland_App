import 'package:bar_iland_app/pages/parkings.dart';
import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../pages/buses_by_city.dart';
import '../pages/shuttles.dart';

class BusesShuttlesManager extends StatelessWidget {
  final MainModel model;
  BusesShuttlesManager(this.model);

  @override
  Widget build(BuildContext context) {
    // fetch all the necessery data
    model.fetchBuses();
    model.fetchStations();
    model.fetchShuttleStations();
    return DefaultTabController(
      length: 3,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text('תחבורה ושאטלים'),
            // create the TabBar (3 Tabs)
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.airport_shuttle),
                  text: 'שאטלים',
                ),
                /*Tab(
                  icon: Icon(Icons.directions_bus),
                  text: 'תחנות',
                ),*/
                Tab(
                  icon: Icon(Icons.directions_bus),
                  text: 'תחבורה',
                ),
                Tab(
                  icon: Icon(FontAwesome5Solid.parking),
                  text: 'חניות',
                ),
              ],
            ),
          ),
          // create the TabBar view (3 Tabs)
          body: TabBarView(
            children: <Widget>[
              Shuttles(model),
              /*Container(),*/
              BusesByCity(model),
              Parkings(model),
            ],
          ),
        ),
      ),
    );
  }
}
