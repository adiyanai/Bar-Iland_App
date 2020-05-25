import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class AddLost extends StatefulWidget {
  final MainModel model;
  AddLost(this.model);

  @override
  State<StatefulWidget> createState() {
    return AddLostState();
  }
}

class AddLostState extends State<AddLost> {
  ScrollController _typesScrollController = ScrollController();
  String _pageTitle = "סוג האבידה";
  Color _nextButtonColor = Colors.grey;
  bool _isPreviousButtonVisible = false;
  String _selectedType = "";
  String _name = "";
  String _phoneNumber = "";
  String _description = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _phoneNumberFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            _pageTitle,
          ),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/lost_found.jpg'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: widget.model.isLostFoundLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildPageContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    return Stack(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 60),
          child: _currentPageContent()),
      Container(
        padding: EdgeInsets.only(top: 500),
        child: _navigationButtons(),
      )
    ]);
  }

  Widget _currentPageContent() {
    switch (_pageTitle) {
      case "סוג האבידה":
        return _lostTypeContent();
        break;
      case "פרטים נוספים":
        return _moreDetailsContent();
      default:
        return Container();
    }
  }

  Widget _lostTypeContent() {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _typesScrollController,
      child: ListView(controller: _typesScrollController, children: [
        Container(
          color: Color.fromRGBO(220, 250, 250, 0.7),
          child: RadioButtonGroup(
            picked: _selectedType,
            padding: EdgeInsets.only(right: 0),
            labels: widget.model.LostFoundTypes,
            onSelected: (String selected) => {
              setState(() {
                _selectedType = selected;
                _nextButtonView(_pageTitle);
              })
            },
          ),
        )
      ]),
    );
  }

  Widget _moreDetailsContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      color: Color.fromRGBO(220, 250, 250, 0.7),
      child: Column(
        children: <Widget>[
          _nameFormField(),
          _phoneNumberFormField(),
          _descriptionFormField(),
          _note()
        ],
      ),
    );
  }

  Widget _nameFormField() {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(30),
        ],
        onChanged: (value) {
          _name = value;
          setState(() {
            _nextButtonView(_pageTitle);
          });
        },
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _nameFocus, _phoneNumberFocus);
        },
        decoration: InputDecoration(
          hintText: "שם פרטי ו/או שם משפחה",
          icon: Icon(Icons.person),
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _phoneNumberFormField() {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        textInputAction: TextInputAction.next,
        focusNode: _phoneNumberFocus,
        onChanged: (value) {
          _phoneNumber = value;
          setState(() {
            _nextButtonView(_pageTitle);
          });
        },
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _phoneNumberFocus, _descriptionFocus);
        },
        decoration: InputDecoration(
          hintText: "טלפון ליצירת קשר",
          icon: Icon(Icons.phone),
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _descriptionFormField() {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
          controller: _descriptionController,
          textInputAction: TextInputAction.done,
          focusNode: _descriptionFocus,
          inputFormatters: [
            LengthLimitingTextInputFormatter(60),
          ],
          decoration: new InputDecoration(
            hintText: "תיאור האבידה וסימנים ייחודיים (לא חובה)",
            icon: new Icon(MaterialCommunityIcons.file_document_edit_outline),
          ),
          onChanged: (value) {
            _description = value;
          },
          onFieldSubmitted: (value) {
            _descriptionFocus.unfocus();
          }),
    );
  }

  Widget _navigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: _isPreviousButtonVisible,
          replacement: SizedBox(width: 89),
          child: RaisedButton(
            child: Text(
              'הקודם',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
              setState(() {
                switch (_pageTitle) {
                  case "פרטים נוספים":
                    _pageTitle = "סוג האבידה";
                    setState(() {
                      _nextButtonView(_pageTitle);
                      _isPreviousButtonVisible = false;
                    });
                }
              });
            },
          ),
        ),
        RaisedButton(
          child: Text(
            'ביטול',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/lostFound');
          },
        ),
        RaisedButton(
          child: Text(
            'הבא',
            style: TextStyle(color: Colors.white),
          ),
          color: _nextButtonColor,
          onPressed: () {
            setState(() {
              switch (_pageTitle) {
                case "סוג האבידה":
                  _pageTitle = "פרטים נוספים";
                  setState(() {
                    _nextButtonView(_pageTitle);
                    _isPreviousButtonVisible = true;
                  });
              }
            });
          },
        ),
      ],
    );
  }

  Widget _note() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 80, 20, 0),
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "שימ/י ",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Icon(MaterialCommunityIcons.heart, color: Colors.blue),
            Text(
              ":",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text("המידע יוצג לשאר משתמשי האפליקציה",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue))
          ],
        )
      ]),
    );
  }

  void _nextButtonView(String pageTitle) {
    switch (pageTitle) {
      case "סוג האבידה":
        if (_selectedType != "") {
          _nextButtonColor = Colors.blue;
        } else {
          _nextButtonColor = Colors.grey;
        }
        break;
      case "פרטים נוספים":
        if (_name.length >= 2 && _phoneNumber.length == 10) {
          _nextButtonColor = Colors.blue;
        } else {
          _nextButtonColor = Colors.grey;
        }
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
