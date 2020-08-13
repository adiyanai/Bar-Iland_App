import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../scoped-models/main.dart';
import '../models/event_location.dart';

class AddEvent extends StatefulWidget {
  final MainModel _model;
  final DateTime _selectedDay;
  final Map<String, Icon> _eventTypesToIcons;

  AddEvent(this._model, this._selectedDay, this._eventTypesToIcons);

  @override
  State<StatefulWidget> createState() {
    return AddEventState();
  }
}

class AddEventState extends State<AddEvent> {
  final GlobalKey<FormState> _textFieldKey = GlobalKey<FormState>();
  String _selectedEventType = '';
  String _selectedLocation = '';
  String _descriptionText = '';
  TimeOfDay _selectedTime;
  String _timeText = '';
  List<bool> _canSubmit = [false, false, false];
  AppBar _appBar;
  List<String> _eventTypes;
  List<EventLocation> _eventLocations;

  @override
  void initState() {
    super.initState();
    // fetch all the necessery data
    initEventType();
    initEventsLocations();
  }

  // fetch the EventType data if not fetched yet
  void initEventType() async {
    if (widget._model.EventTypes.isEmpty) {
      await widget._model.fetchEventTypes();
    }
    setState(() {
      _eventTypes = widget._model.EventTypes;
    });
  }

  // fetch the EventsLocations data if not fetched yet
  void initEventsLocations() async {
    if (widget._model.EventsLocations.isEmpty) {
      await widget._model.fetchEventsLocations();
    }
    setState(() {
      _eventLocations = widget._model.EventsLocations;
    });
  }

  // build the backgroung image
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/people_party.png'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.7),
        BlendMode.dstATop,
      ),
    );
  }

  // build the dropdown menu items of the event types
  List<DropdownMenuItem<String>> _buildDropdownMenuItemsEventType() {
    List<DropdownMenuItem<String>> items = List();
    for (String eventType in _eventTypes) {
      items.add(
        DropdownMenuItem(
          value: eventType,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                // take the icon that belongs to this event type
                widget._eventTypesToIcons[eventType],
                SizedBox(
                  width: 4,
                ),
                Text(
                  eventType,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  // build the dropdown menu items of the event locations
  List<DropdownMenuItem<String>> _buildDropdownMenuItemsEventLocations() {
    List<DropdownMenuItem<String>> items = List();
    for (EventLocation locationData in _eventLocations) {
      items.add(
        DropdownMenuItem(
          value: locationData.NumberName,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              locationData.NumberName,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),
      );
    }
    items.add(
      DropdownMenuItem(
        value: 'אירוע כללי',
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'אירוע כללי',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
    return items;
  }

  // select the time of the event
  Future<Null> _selectTime(BuildContext context) async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      // save the time the user picked
      if (_selectedTime != null) {
        _timeText = _selectedTime.toString().substring(10, 15);
        _canSubmit[2] = true;
      } else {
        _timeText = '';
        _canSubmit[2] = false;
      }
    });
  }

  // build the page
  Widget _buildPage() {
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: _screenHeight - _appBar.preferredSize.height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // create the 'cancel' and 'ok' buttons
            Positioned.fill(
              top: 550,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // cancel button
                  RaisedButton(
                    child: Text(
                      'ביטול',
                    ),
                    // when pressed go back to the event calendar
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/eventsCalendar');
                    },
                  ),
                  // ok button
                  RaisedButton(
                    child: Text(
                      'אישור',
                    ),
                    // just when the user fill all the necessery data he can press the ok button
                    color: (_canSubmit[0] && _canSubmit[1] && _canSubmit[2])
                        ? Colors.blue
                        : Colors.grey,
                    onPressed: () {
                      if (_canSubmit[0] && _canSubmit[1] && _canSubmit[2]) {
                        setState(() {
                          // add the new event
                          widget._model.addEvent(
                              widget._selectedDay,
                              _timeText,
                              _selectedLocation,
                              _selectedEventType,
                              _descriptionText,
                              widget._model);
                          // go back to the event calendar
                          Navigator.pushReplacementNamed(
                              context, '/eventsCalendar');
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            // create the 'more information' TextField
            Positioned(
              top: 360,
              child: Container(
                height: 200,
                width: 300,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'תיאור נוסף',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '- לא חובה',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 300,
                      // the 'more information' TextField
                      child: TextField(
                        key: _textFieldKey,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        maxLength: 65,
                        decoration: InputDecoration(
                          hintText: 'הקלד כאן...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white60,
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                        onChanged: (String description) {
                          // save the 'more information' the user typed
                          _descriptionText = description;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // create the select time clock
            Positioned(
              top: 240,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'שעה',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(5),
                            icon: Icon(
                              /*Icons.alarm,*/
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            // select the time of the event
                            onPressed: () => _selectTime(context),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          // show the time the user has chosen
                          _timeText,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // create dropdown menu items of the event locations
            Positioned(
              top: 120,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'מיקום',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: 290,
                        child: SearchableDropdown.single(
                          keyboardType: TextInputType.text,
                          iconSize: 24,
                          dialogBox: false,
                          menuConstraints:
                              BoxConstraints.tight(Size.fromHeight(200)),
                          // create dropdown menu items of the event locations
                          items: _buildDropdownMenuItemsEventLocations(),
                          value: _selectedLocation,
                          closeButton: SizedBox.shrink(),
                          displayClearIcon: false,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              // save the location the user picked
                              _selectedLocation = value;
                              if (_selectedLocation != '') {
                                _canSubmit[1] = true;
                              } else {
                                _canSubmit[1] = false;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // create dropdown menu items of the event types
            Positioned(
              top: 0,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'סוג אירוע',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: 180,
                        child: SearchableDropdown.single(
                          keyboardType: TextInputType.text,
                          iconSize: 24,
                          dialogBox: false,
                          menuConstraints:
                              BoxConstraints.tight(Size.fromHeight(200)),
                          // create dropdown menu items of the event types
                          items: _buildDropdownMenuItemsEventType(),
                          value: _selectedEventType,
                          closeButton: SizedBox.shrink(),
                          displayClearIcon: false,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              // save the event type the user picked
                              _selectedEventType = value;
                              if (_selectedEventType != '') {
                                _canSubmit[0] = true;
                              } else {
                                _canSubmit[0] = false;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          overflow: Overflow.visible,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _appBar = AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            'הוספת אירוע',
          ),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Container(
              // build the background image
              decoration: BoxDecoration(
                image: _buildBackgroundImage(),
              ),
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                // if all the data fetched show the page, else show CircularProgressIndicator
                child: widget._model.isEventTypeLoading ||
                        widget._model.isEventsLocationsLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    // build tha page
                    : _buildPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
