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
          // leading: FlatButton(child: Icon(Icons.home, color: Colors.white,), onPressed: (){},),
          centerTitle: true,
          title: Center(child: Text('שירותים באוניברסיטה')),
          actions: <Widget>[ButtonTheme(minWidth: 80, child: FlatButton(child: Icon(Icons.arrow_forward, color: Colors.white, size: 26,), onPressed: (){
            Navigator.pushReplacementNamed(context, '/');
          },))],
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
