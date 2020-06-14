import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import '../pages/buses_by_city.dart';
import '../pages/shuttles.dart';

class BusesShuttlesManager extends StatelessWidget {
  final MainModel model;
  BusesShuttlesManager(this.model);

  @override
  Widget build(BuildContext context) {
    model.fetchBuses();
    model.fetchStations();
    model.fetchShuttleStations();
    return DefaultTabController(
      length: 4,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text('תחבורה ושאטלים'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.directions_railway),
                  text: 'שאטלים',
                ),
                Tab(
                  icon: Icon(Icons.directions_bus),
                  text: 'תחנות',
                ),
                Tab(
                  icon: Icon(Icons.location_city),
                  text: 'קו לפי עיר',
                ),
                Tab(
                  icon: Icon(Icons.directions_car),
                  text: 'חניות',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Shuttles(model),
              Container(),
              BusesByCity(model),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
