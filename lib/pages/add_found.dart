import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../scoped-models/main.dart';

// class AddFound is responsible for the view of adding found item page.
class AddFound extends StatefulWidget {
  final MainModel model;
  AddFound(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AddFoundState();
  }
}

class _AddFoundState extends State<AddFound> {
  ScrollController _typesScrollController = ScrollController();
  ScrollController _locationsScrollController = ScrollController();
  String _pageTitle = "סוג המציאה";
  Color _nextButtonColor = Colors.grey;
  String _nextButtonText = "הבא";
  bool _isNextNotPressable = true;
  bool _isPreviousButtonVisible = false;
  String _selectedType = "";
  String _takenOrNot = "";
  String _name = "";
  String _phoneNumber = "";
  String _description = "";
  String _selectedArea = "";
  String _specificLocation = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _specificLocationController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _phoneNumberFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();
  FocusNode _specificLocationFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<File> _futureImageFile;
  File _imageFile;
  String _imageUrl = "";
  Widget _image;
  bool _isAddFoundLoading = false;

  @override
  void initState() {
    super.initState();
    _image = initialImageContainer();
  }

  // The UI of the initial container of the image.
  Widget initialImageContainer() {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Center(
        child: Text(
          "צלמ/י את המציאה על מנת להקל על המאבד/ת למצוא אותה.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            _pageTitle,
          ),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                width: MediaQuery.of(context).size.width,
                // The background of the page.
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
                  child: widget.model.isFoundLoading || _isAddFoundLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildPageContent(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Build the content of the page.
  Widget _buildPageContent() {
    return Stack(children: [
      Container(
          height: MediaQuery.of(context).size.height - 130,
          padding: EdgeInsets.fromLTRB(0, 20, 0, 60),
          child: _currentPageContent()),
      Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height - 150),
        child: _navigationButtons(),
      ),
    ]);
  }
  
  // Build the content of the current page.
  Widget _currentPageContent() {
    switch (_pageTitle) {
      case "סוג המציאה":
        return _foundTypeContent();
        break;
      case "פרטים נוספים":
        return _moreDetailsContent();
        break;
      case "פרטים ליצירת קשר":
        return _contactDetailsContent();
        break;
      case "מיקום המציאה":
        return _locationContent();
        break;
      case "תמונה":
        return _addingPictureContent();
        break;
      default:
        return Container();
    }
  }
  
  // The content of the page that enables the user to report about the type of the found item.
  Widget _foundTypeContent() {
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

  // The content of the page that enables the user to write more details about the found item.
  Widget _moreDetailsContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      color: Color.fromRGBO(220, 250, 250, 0.7),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            _descriptionFormField(),
            SizedBox(height: 90),
            _isTakenOrNot(),
          ],
        ),
      ),
    );
  }

  // The content of the page that enables the user to write his contact details.
  Widget _contactDetailsContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      color: Color.fromRGBO(220, 250, 250, 0.7),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _nameFormField(),
            _phoneNumberFormField(),
            _note()
          ],
        ),
      ),
    );
  }

  // The content of the page that enables the user to report about the location of the found item.
  Widget _locationContent() {
    List<String> lostFoundLocations = [];
    widget.model.LostFoundLocations.forEach((location) {
      lostFoundLocations.add(location.Number + " - " + location.Name);
    });
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 310,
          width: 400,
          color: Color.fromRGBO(220, 250, 250, 0.7),
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _locationsScrollController,
            child: ListView(controller: _locationsScrollController, children: [
              RadioButtonGroup(
                  padding: EdgeInsets.only(right: 0),
                  picked: _selectedArea,
                  labels: lostFoundLocations,
                  onSelected: (String selected) => {
                        setState(() {
                          _selectedArea = selected;
                          _nextButtonView(_pageTitle);
                        })
                      })
            ]),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height - 555,
            width: 400,
            padding: EdgeInsets.only(bottom: 30),
            margin: EdgeInsets.only(top: 15),
            color: Color.fromRGBO(220, 250, 250, 0.7),
            child: _specificLocationFormField()),
      ],
    );
  }

  // This function enables the user to add a photo of the found item.
  void _cameraPhoto(ImageSource source) {
    setState(() {
      _futureImageFile = ImagePicker.pickImage(source: source);
    });
  }
  
  // Showing the image that the user added.
  Widget _showImage() {
    return FutureBuilder<File>(
        future: _futureImageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            _imageFile = snapshot.data;
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(MaterialCommunityIcons.trash_can),
                      textColor: Colors.white,
                      color: Colors.blue,
                      label: Text("הסרת התמונה"),
                      onPressed: () {
                        setState(() {
                          _image = initialImageContainer();
                        });
                      },
                    ),
                  ],
                ),
                Image.file(snapshot.data,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height - 300,
                    width: 400)
              ],
            );
          } else
            return initialImageContainer();
        });
  }

  // The content of the page that enables the user to add a photo of the found item.
  Widget _addingPictureContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(220, 250, 250, 0.7),
      child: Stack(
        children: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.add_a_photo),
            textColor: Colors.white,
            color: Colors.blue,
            label: Text("צילום תמונה"),
            onPressed: () {
              _cameraPhoto(ImageSource.camera);
              setState(() {
                _image = _showImage();
              });
            },
          ),
          _image,
        ],
      ),
    );
  }
  
  // A form field for the name of the reporter.
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
        validator: (value) {
          if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
            return 'יש להזין שם המכיל אותיות בלבד';
          }
          if (value.length < 2) {
            return 'יש להזין שם המכיל שתי אותיות לפחות';
          }
        },
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

  // A form field for the phone number of the reporter.
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
        validator: (value) {
          if (value.isEmpty || !RegExp(r"^[0][5][0-9]{8}$").hasMatch(value)) {
            return 'יש להזין מספר טלפון תקין';
          }
        },
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
          hintText: "טלפון נייד ליצירת קשר",
          icon: Icon(Icons.phone),
          fillColor: Colors.white,
        ),
      ),
    );
  }
  
  // A form field for the description of the found item.
  Widget _descriptionFormField() {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
          minLines: 2,
          maxLines: 2,
          controller: _descriptionController,
          textInputAction: TextInputAction.done,
          focusNode: _descriptionFocus,
          inputFormatters: [
            LengthLimitingTextInputFormatter(60),
          ],
          decoration: new InputDecoration(
            hintText: "תיאור המציאה וסימנים ייחודיים (לא חובה)",
            icon: new Icon(MaterialCommunityIcons.information_outline),
          ),
          onChanged: (value) {
            _description = value;
          },
          onFieldSubmitted: (value) {
            _descriptionFocus.unfocus();
          }),
    );
  }
  
  // A form field for the specific location of the found item.
  Widget _specificLocationFormField() {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 30),
      child: TextFormField(
          controller: _specificLocationController,
          textInputAction: TextInputAction.done,
          focusNode: _specificLocationFocus,
          inputFormatters: [
            LengthLimitingTextInputFormatter(30),
          ],
          decoration: new InputDecoration(
            hintText: "מיקום מדויק, לדוגמה: כיתה 101 (לא חובה)",
            icon: new Icon(Icons.location_on),
          ),
          onChanged: (value) {
            _specificLocation = value;
          },
          onFieldSubmitted: (value) {
            _specificLocationFocus.unfocus();
          }),
    );
  }
  
  // Whether the reporter wants to take the found item with him or not.
  Widget _isTakenOrNot() {
    return Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(50, 0, 0, 10),
          child: Text("מה בכוונתך לעשות עם המציאה?",
              style: TextStyle(fontSize: 19))),
      SizedBox(height: 10),
      RadioButtonGroup(
        picked: _takenOrNot,
        padding: EdgeInsets.only(right: 0),
        labelStyle: TextStyle(fontSize: 16),
        labels: ["לקחת אותה איתי", "להשאיר אותה במקומה"],
        onSelected: (String selected) => {
          setState(() {
            _takenOrNot = selected;
            _nextButtonView(_pageTitle);
          }),
        },
        onChange: (String selected, int index) {
          setState(() {
            _name = "";
            _phoneNumber = "";
            _specificLocation = "";
          });
        },
      )
    ]);
  }
  
  // Build the navigation buttons between the different reporting pages.
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
                    _isNextNotPressable = false;
                    _pageTitle = "סוג המציאה";
                    _nextButtonView(_pageTitle);
                    _isPreviousButtonVisible = false;
                    break;
                  case "פרטים ליצירת קשר":
                    _pageTitle = "פרטים נוספים";
                    _nextButtonView(_pageTitle);
                    break;
                  case "מיקום המציאה":
                    _pageTitle = "פרטים נוספים";
                    _nextButtonView(_pageTitle);
                    break;
                  case "תמונה":
                    if (_takenOrNot == "לקחת אותה איתי") {
                      _pageTitle = "פרטים ליצירת קשר";
                    } else {
                      _pageTitle = "מיקום המציאה";
                    }
                    _nextButtonView(_pageTitle);
                    break;
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
            Navigator.pop(context);
          },
        ),
        IgnorePointer(
          ignoring: _isNextNotPressable,
          child: RaisedButton(
            child: Text(
              _nextButtonText,
              style: TextStyle(color: Colors.white),
            ),
            color: _nextButtonColor,
            onPressed: () {
              setState(() {
                switch (_pageTitle) {
                  case "סוג המציאה":
                    _pageTitle = "פרטים נוספים";
                    _nextButtonView(_pageTitle);
                    _isPreviousButtonVisible = true;
                    break;
                  case "פרטים נוספים":
                    if (_takenOrNot == "לקחת אותה איתי") {
                      _pageTitle = "פרטים ליצירת קשר";
                    } else {
                      _pageTitle = "מיקום המציאה";
                    }
                    _nextButtonView(_pageTitle);
                    break;
                  case "פרטים ליצירת קשר":
                    if (_formKey.currentState.validate()) {
                      _pageTitle = "תמונה";
                      _nextButtonView(_pageTitle);
                    }
                    break;
                  case "מיקום המציאה":
                    _pageTitle = "תמונה";
                    _nextButtonView(_pageTitle);
                    break;
                  case "תמונה":
                    _addFoundToDatabase();
                }
              });
            },
          ),
        ),
      ],
    );
  }
  
  // Add the found item to the database.
  void _addFoundToDatabase() async {
    if (_imageFile != null) {
      _isAddFoundLoading = true;
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("foundImages");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(_imageFile);
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _imageUrl = ImageUrl.toString();
    }
    if (_takenOrNot == "לקחת אותה איתי") {
      _selectedArea = "נלקח עם המוצא/ת";
    }
    widget.model.addFound("found", _selectedType, _name, _phoneNumber,
        _description, _selectedArea, _specificLocation, _imageUrl);
    Navigator.pop(context);
    _isAddFoundLoading = false;
  }
  
  // A note for the user that all the details he writes will be displayed in the application.
  Widget _note() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 80, 20, 0),
      child: Column(
        children: <Widget>[
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
              Text(
                "המידע יוצג לשאר משתמשי האפליקציה",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              )
            ],
          )
        ],
      ),
    );
  }
  
  // Build the UI of the next button.
  void _nextButtonView(String pageTitle) {
    switch (pageTitle) {
      case "סוג המציאה":
        _nextButtonText = "הבא";
        if (_selectedType != "") {
          _nextButtonColor = Colors.blue;
          _isNextNotPressable = false;
        } else {
          _nextButtonColor = Colors.grey;
          _isNextNotPressable = true;
        }
        break;
      case "פרטים נוספים":
        _nextButtonText = "הבא";
        if (_takenOrNot != "") {
          _nextButtonColor = Colors.blue;
          _isNextNotPressable = false;
        } else {
          _nextButtonColor = Colors.grey;
          _isNextNotPressable = true;
        }
        break;
      case "פרטים ליצירת קשר":
        _nextButtonText = "הבא";
        if (_name.length >= 1 && _phoneNumber.length >= 1) {
          _nextButtonColor = Colors.blue;
          _isNextNotPressable = false;
        } else {
          _nextButtonColor = Colors.grey;
          _isNextNotPressable = true;
        }
        break;
      case "מיקום המציאה":
        _nextButtonText = "הבא";
        if (_selectedArea != "") {
          _nextButtonColor = Colors.blue;
          _isNextNotPressable = false;
        } else {
          _nextButtonColor = Colors.grey;
          _isNextNotPressable = true;
        }
        break;
      case "תמונה":
        _nextButtonText = "סיום";
        _nextButtonColor = Colors.blue;
    }
  }

  // Change the focus to the next field.
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
