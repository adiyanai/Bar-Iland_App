import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class HomePage extends StatelessWidget {
  Widget _buildDrawer() {
    return Drawer(
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
            //Expanded(
            //  child: Align(
            //    alignment: Alignment.bottomCenter,
            //    child: _buildLogoutListTile(),
            //  ),
            //),
            _buildLogoutListTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutListTile() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('התנתק'),
          onTap: () {
            model.logout();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Image.asset(
          'assets/Bar_Iland_line.png',
          height: 40,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.account_circle,
              //color: Colors.black54,
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
