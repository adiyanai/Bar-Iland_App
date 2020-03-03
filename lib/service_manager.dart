import 'package:flutter/material.dart';
import './pages/service_by_building.dart';
import './pages/service_by_type.dart';

class ServiceManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('שירותים באוניברסיטה')),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.business),
                text: 'לפי בניין',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'לפי סוג שירות',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ServiceByBuilding(), ServiceByType()],
        ),
      ),
    );
  }
}
