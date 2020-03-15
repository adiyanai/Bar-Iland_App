import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class HomePage extends StatelessWidget {

  Widget _buildLogoutListTile() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('התנתק'),
          onTap: () {
            model.logout();
            Navigator.of(context).pushReplacementNamed('/');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
              ),
              ListTile(
                leading: Icon(Icons.school),
                title: Text('סטודנט'),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('אורח'),
                onTap: () {},
              ),
              Divider(),
              _buildLogoutListTile(),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Bar-Iland'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Container(
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'שירותים באוניברסיטה',
            style: TextStyle(fontSize: 15.0),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/service_manager');
          },
        ),
      ),
    );
  }
}
