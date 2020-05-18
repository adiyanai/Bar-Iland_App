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
    initEventType();
    initEventsLocations();
  }

  void initEventType() async {
    if (widget._model.EventTypes.isEmpty) {
      await widget._model.fetchEventTypes();
    }
    setState(() {
      _eventTypes = widget._model.EventTypes;
    });
  }

  void initEventsLocations() async {
    if (widget._model.EventsLocations.isEmpty) {
      await widget._model.fetchEventsLocations();
    }
    setState(() {
      _eventLocations = widget._model.EventsLocations;
    });
  }

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
        value: 'אחר',
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'אחר',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
    return items;
  }

  Future<Null> _selectTime(BuildContext context) async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      if (_selectedTime != null) {
        _timeText = _selectedTime.toString().substring(10, 15);
        _canSubmit[2] = true;
      } else {
        _timeText = '';
        _canSubmit[2] = false;
      }
    });
  }

  Widget _buildPage() {
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: _screenHeight - _appBar.preferredSize.height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              top: 550,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    child: Text(
                      'ביטול',
                      //style: TextStyle(color: Colors.white ,fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    //color: Colors.indigo[400],
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/eventsCalendar');
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'אישור',
                      //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    color: (_canSubmit[0] && _canSubmit[1] && _canSubmit[2])
                        ? Colors.blue
                        : Colors.grey,
                    onPressed: () {
                      if (_canSubmit[0] && _canSubmit[1] && _canSubmit[2]) {
                        setState(() {
                          widget._model.addEvent(
                              widget._selectedDay,
                              _timeText,
                              _selectedLocation,
                              _selectedEventType,
                              _descriptionText);
                          Navigator.pushReplacementNamed(
                              context, '/eventsCalendar');
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
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
                          _descriptionText = description;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                            onPressed: () => _selectTime(context),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
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
                          items: _buildDropdownMenuItemsEventLocations(),
                          value: _selectedLocation,
                          closeButton: SizedBox.shrink(),
                          displayClearIcon: false,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
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
                          items: _buildDropdownMenuItemsEventType(),
                          value: _selectedEventType,
                          closeButton: SizedBox.shrink(),
                          displayClearIcon: false,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
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
              decoration: BoxDecoration(
                image: _buildBackgroundImage(),
              ),
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: widget._model.isEventTypeLoading ||
                        widget._model.isEventsLocationsLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
