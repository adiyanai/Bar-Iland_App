import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import './pages/service_by_building.dart';
import './pages/service_by_type.dart';

class ServiceManager extends StatelessWidget {
  final MainModel model;
  ServiceManager(this.model);

  @override
  Widget build(BuildContext context) {
    model.fetchServices();
    return DefaultTabController(
      length: 2,
      child: Directionality(textDirection: TextDirection.rtl, child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Center(child: Text('שירותים באוניברסיטה')),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
                text: 'לפי סוג שירות',
              ),
              Tab(
                icon: Icon(Icons.business),
                text: 'לפי בניין',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ServiceByType(model), ServiceByBuilding(model)],
        ),
      ),
    ));
  }
}