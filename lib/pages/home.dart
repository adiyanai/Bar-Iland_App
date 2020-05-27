
import 'package:bar_iland_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/connection.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
    final MainModel _model;
    HomePage(this._model);
    List<Event> eventsData = [];
    List<Event> events = [];

    void initEvents()async{
      await _model.fetchEvents();
      eventsData = _model.allEvents;
      if(_model.isEventsLoading){
        CircularProgressIndicator();
      }
      events = getEventsOfCurrentDay(eventsData);
    }

  List<Event> getEventsOfCurrentDay(List<Event>events_data){
      DateTime tomorrow  = DateTime(2020,04,15);
      DateTime today = new DateTime.now(); 
      List <Event> todays_events = [];
      String tomorrow_date  = today.toString().substring(0,10);
      eventsData.forEach((event) {
      String event_date = event.date.toString().substring(0,10);
        if(tomorrow_date == event_date){
          todays_events.add(event);
        }
      });
      return todays_events;
    }

  Widget _buildAnnouncementBoard(BuildContext context,Event event){
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
      child:Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 150,
          padding: EdgeInsets.only(left: 4,right: 1,bottom: 22,top: 1),
          decoration: BoxDecoration(
            color: Colors.white38,
            border: Border.all(
              color: Colors.black26,
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ListTile(
            contentPadding:EdgeInsets.only(left: 0,right: 28,bottom: 30,top: 35),
            title: Center( heightFactor: 7,child: Text(
              'אירועי היום',
              style: TextStyle(
                fontSize: 18,
                height: 0,
                color: Colors.deepPurple[700],
              ),
            )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        size: 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 3),
                      Container(
                        width: _screenWidth * 0.60,
                        child: Text(
                          event.EventType,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 3),
                      Container(
                        width: _screenWidth * 0.60,
                        child: Text(
                          event.Location,
                          style:TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height:5),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 15,
                      color: Colors.black,
                    ),
                    SizedBox(width: 3),
                    Text(
                      event.Time,
                      style:TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    )));
  }

  Widget _buildDrawer() {
    return Drawer(
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

  DecorationImage _buildBackgroungImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.55),
        BlendMode.dstATop,
      ),
    );
  }

Container _buildEventsBoard(List<Event> todays_events){
  SizedBox(height:4);
  return Container(
        margin: EdgeInsets.all(2),
        width: 30,
        height: 180,
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.only(left: 0,right: 0,bottom:5 ,top:6),
          child: Container(
            child: Swiper(
            //control:SwiperControl(),
            itemCount: todays_events.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildAnnouncementBoard(context,todays_events[index]);
            },
            loop: false,
            pagination: SwiperPagination(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(20),
            )
            ),
        // decoration: BoxDecoration(
        //   color: Colors.lightBlue[100],
        //   borderRadius: BorderRadius.circular(20),
        //   border: Border.all(color: Colors.blue, width: 4.0),
        //   ),   
  ));
}

  @override
  Widget build(BuildContext context) {
    initEvents(); 
       return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: _buildDrawer(),
          appBar: AppBar(
            title: Container(padding: EdgeInsets.only(right: 70), child: Row(children: [Text("דף הבית  "), Icon(Icons.home)])),
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
            decoration: BoxDecoration(
              image: _buildBackgroungImage(),
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/Bar_Iland_line.png',
                    height: 100,
                    width: 30,
                    color: Colors.black,
                  ),
                  SizedBox(height: 16),
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
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/serviceManager');
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.business), // icon
                                    Text(
                                      'שירותי האוניברסיטה',
                                      style: TextStyle(fontSize: 13),
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
                                  Navigator.pushNamed(
                                      context, '/eventsCalendar');
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
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
                        SizedBox.fromSize(
                          size: Size(90, 90), // button width and height
                          child: ClipOval(
                            child: Material(
                              color: Colors.lightBlue[200], // button color
                              child: InkWell(
                                splashColor: Colors.cyanAccent, // splash color
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/importantLinks');}, // button pressed
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
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/lostFound');
                                },
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
                      ]),
                        events.isNotEmpty
                        ?_buildEventsBoard(events)
                   :SizedBox(height: 183),
                   Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.only(bottom: 10, top: 3, right: 10),
                      child: RaisedButton(
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(7),
                            bottom: Radius.circular(7))),
                        color: Colors.lightBlue[200], // button color
                        splashColor: Colors.cyanAccent, // splash color
                        onPressed: () =>
                            Navigator.pushNamed(context, '/campusMap'),
                        child: Text('מפת הקמפוס',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center),
                    )
                  ),   
                ],
              ),
            ),
          ),
        ));
      }
  }
