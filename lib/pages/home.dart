import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/connection.dart';

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
            if (model.connectionMode == ConnectionMode.RegisteredUser) {
              model.logout();
            }
            Navigator.pushReplacementNamed(context, '/');
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
      body: ListView(
        children: <Widget>[
          Image.asset(
            'assets/Bar_Iland_line.png',
            height: 150,
            width: 30,
            color: Colors.black,
          ),
          SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.fromSize(
                size: Size(90, 90), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlue[200], // button color
                    child: InkWell(
                      splashColor: Colors.cyanAccent, // splash color
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.info_outline), // icon
                          Text("מידע על",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center), // text
                          Text(
                            "קורסים",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(90, 90), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlue[200], // button color
                    child: InkWell(
                      splashColor: Colors.cyanAccent, // splash color
                      onTap: () {
                        Navigator.pushNamed(context, '/events');
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.event), // icon
                          Text(
                            'אירועים ',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(90, 90), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlue[200], // button color
                    child: InkWell(
                      splashColor: Colors.cyanAccent, // splash color
                      onTap: () {
                        Navigator.pushNamed(context, '/service_manager');
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.business), // icon
                          Text(
                            'שירותים באוניברסיטה',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.fromSize(
                size: Size(90, 90), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlue[200], // button color
                    child: InkWell(
                      splashColor: Colors.cyanAccent, // splash color
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.find_in_page), // icon
                          Text(
                            'אבידות ומציאות ',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(90, 90), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlue[200], // button color
                    child: InkWell(
                      splashColor: Colors.cyanAccent, // splash color
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.link), // icon
                          Text(
                            'קישורים חשובים',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ) // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.fromSize(
                size: Size(90, 90), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlue[200], // button color
                    child: InkWell(
                      splashColor: Colors.cyanAccent, // splash color
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.directions_bus), // icon
                          Text(
                            'תחבורה ושאטלים',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
