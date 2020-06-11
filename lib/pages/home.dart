import 'package:bar_iland_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../scoped-models/main.dart';
import '../models/connection.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomePage extends StatelessWidget {
  final MainModel _model;
  HomePage(this._model) {
    _eventTypesToIcons = _mapEventTypesToIcons();
  }
  Map<String, Icon> _eventTypesToIcons;
  List<Event> eventsData = [];
  List<Event> events = [];

  Map<String, Icon> _mapEventTypesToIcons() {
    Map<String, Icon> eventsToIcons = {
      "סטנדאפ": Icon(IconData(0xe24e, fontFamily: 'MaterialIcons'), size: 15),
      "הרצאה/כנס": Icon(Icons.school, size: 15),
      "ספורט": Icon(MdiIcons.basketball, size: 15),
      "הפאב החברתי": Icon(FontAwesome5Solid.beer, size: 15),
      "שבת בקמפוס": Icon(MaterialCommunityIcons.candle, size: 15),
      "הופעה": Icon(MdiIcons.microphoneVariant, size: 15),
      "TimeOut": Icon(MdiIcons.cookie, size: 15),
      "מדרשה": Icon(MaterialCommunityIcons.book_open_page_variant, size: 15),
      "הפססקר":
          Icon(MaterialCommunityIcons.file_document_edit_outline, size: 15),
      "קפה ומאפה": Icon(MaterialCommunityIcons.coffee, size: 15),
      "קבלת שבת": Icon(MaterialCommunityIcons.candle, size: 15),
      "Live בקמפוס": Icon(MdiIcons.microphoneVariant, size: 15),
      "אחר": Icon(MaterialCommunityIcons.dots_horizontal, size: 15),
      "מסיבה": Icon(MdiIcons.balloon, size: 15),
      "טקס": Icon(MdiIcons.microphoneVariant, size: 15)
    };
    return eventsToIcons;
  }

String mapEventTypeToTitle(Event event){
  String eventTitle;
    if(event.EventType == 'קפה ומאפה'){
    eventTitle =  'Keep calm and drink coffee';
    }
    else if (event.EventType == 'מסיבה' || event.EventType == 'הפאב החברתי'){
    eventTitle = "!Let's party";
    }
     else if (event.EventType == 'הופעה' || event.EventType == 'Live בקמפוס'){
      eventTitle = '!The show must go on';
    }
     else if (event.EventType == 'הרצאה/כנס' || event.EventType == 'טקס'){
      eventTitle = 'אירועי היום';
    }
     else if (event.EventType == 'ספורט'){
      eventTitle = '!Support the sport';
    }
     else if (event.EventType == 'מדרשה'){
      eventTitle = 'רק בגלל הרוח';
    }
     else if (event.EventType == 'הפססקר'){
      eventTitle = 'מי שמצביע - משפיע!';
    }
     else if (event.EventType == 'TimeOut'){
      eventTitle = 'צריכים פסק זמן מהלימודים?';
    }
     else if (event.EventType == 'קבלת שבת' || event.EventType == 'שבת בקמפוס'){
      eventTitle = '"פני שבת נקבלה.."';
    }
    else if (event.EventType == 'סטנדאפ'){
      eventTitle = 'Life is tough so laugh hard';
    }
    else if (event.EventType == 'אחר'){
      eventTitle = 'היה לך יום גרוע? בו לאירוע!';
    }
  return eventTitle;
}

  Future<List<Event>> initEvents() async {
    await _model.fetchEvents();
    eventsData = _model.allEvents;
    return eventsData;
  }

  List<Event> getEventsOfCurrentDay(List<Event> events_data) {
    DateTime tomorrow = DateTime(2020, 04, 15);
    DateTime today = new DateTime.now();
    List<Event> todays_events = [];
    String tomorrow_date = tomorrow.toString().substring(0, 10);
    events_data.forEach((event) {
      String event_date = event.date.toString().substring(0, 10);
      if (tomorrow_date == event_date) {
        todays_events.add(event);
      }
    });
    return todays_events;
  }


  Widget _buildAnnouncementBoard(BuildContext context, Event event) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              height: 150,
              padding: EdgeInsets.only(
                right: 10,
                top: 1,
              ),
              decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.only(
                  top: 34,
                ),
                title: Center(
                  heightFactor: 7,
                  child: Text(
                    mapEventTypeToTitle(event),
                    style: TextStyle(
                      fontSize: 18,
                      height: 0,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _eventTypesToIcons[event.EventType],
                        SizedBox(width: 3),
                        Container(
                          width: _screenWidth * 0.60,
                          child: Text(
                            event.EventType,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
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
                        SizedBox(
                          width: 3,
                        ),
                        Container(
                          width: _screenWidth * 0.60,
                          child: Text(
                            event.Location,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 15,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          event.Time,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          leading: Icon(
            Icons.exit_to_app,
          ),
          title: Text(
            'התנתק',
          ),
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

  Container _buildBackgroungImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.55),
            BlendMode.dstATop,
          ),
        ),
      ),
    );
  }

  Container _buildEventsBoard(List<Event> todays_events) {
    return Container(
      margin: EdgeInsets.only(bottom:1),
      width: 30,
      height: 180,
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.only(
        bottom: 5,
      ),
      child: Container(
        child: CarouselSlider.builder(
          //control:SwiperControl(),
          itemCount: todays_events.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildAnnouncementBoard(context, todays_events[index]);
          }, 
          options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.8,
          aspectRatio: 2.0,
          initialPage: 2,
        
        ),
          // loop: false,
          // pagination: SwiperPagination(
          //   alignment: Alignment.bottomCenter,
          //   margin: EdgeInsets.all(24),
          // ),
        ),
        // decoration: BoxDecoration(
        //   color: Colors.lightBlue[100],
        //   borderRadius: BorderRadius.circular(20),
        //   border: Border.all(color: Colors.blue, width: 4.0),
        //   ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initEvents(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            eventsData = snapshot.data;
          } else {
            return Stack(
              children: <Widget>[
                _buildBackgroungImage(),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
        }
        return _build(context);
      },
    );
  }

  Widget _build(BuildContext context) {
    events = getEventsOfCurrentDay(eventsData);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: _buildDrawer(),
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(
              right: 70,
            ),
            child: Row(
              children: [
                Text(
                  "דף הבית  ",
                ),
                Icon(
                  Icons.home,
                ),
              ],
            ),
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
        body: Stack(
          children: <Widget>[
            _buildBackgroungImage(),
            Container(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    Image.asset(
                      'assets/Bar_Iland_line.png',
                      height: 100,
                      width: 30,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 16,
                    ),
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
                                    Icon(
                                      Icons.business,
                                    ), // icon
                                    Text(
                                      'שירותי האוניברסיטה',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
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
                                    Icon(
                                      Icons.event,
                                    ), // icon
                                    Text(
                                      'אירועים ',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
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
                                      context, '/coursesInformation');
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.info_outline,
                                    ), // icon
                                    Text(
                                      "מידע על",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ), // text
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
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/busesShuttlesmanager');
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.directions_bus,
                                    ), // icon
                                    Text(
                                      'תחבורה ושאטלים',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
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
                                      context, '/importantLinks');
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.link,
                                    ), // icon
                                    Text(
                                      'קישורים חשובים',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
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
                                  Navigator.pushNamed(context, '/lostFound');
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.find_in_page,
                                    ), // icon
                                    Text(
                                      'אבידות ומציאות ',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    events.isNotEmpty
                        ? _buildEventsBoard(events)
                        : SizedBox(height: 180),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.only(
                        bottom: 20,
                        right: 10,
                      ),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(7),
                            bottom: Radius.circular(7),
                          ),
                        ),
                        color: Colors.lightBlue[200], // button color
                        splashColor: Colors.cyanAccent, // splash color
                        onPressed: () =>
                            Navigator.pushNamed(context, '/campusMap'),
                        child: Text(
                          'מפת הקמפוס',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
