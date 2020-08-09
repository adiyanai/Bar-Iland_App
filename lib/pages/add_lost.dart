import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../scoped-models/main.dart';

class AddLost extends StatefulWidget {
  final MainModel model;
  AddLost(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AddLostState();
  }
}

class _AddLostState extends State<AddLost> {
  ScrollController _typesScrollController = ScrollController();
  ScrollController _locationsScrollController = ScrollController();
  String _pageTitle = "סוג האבידה";
  Color _nextButtonColor = Colors.grey;
  String _nextButtonText = "הבא";
  bool _isNextNotPressable = true;
  bool _isPreviousButtonVisible = false;
  String _selectedType = "";
  String _name = "";
  String _phoneNumber = "";
  String _description = "";
  List<String> _selOptionalLostLocations = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _phoneNumberFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<File> _futureImageFile;
  File _imageFile;
  String _imageUrl = "";
  Widget _image = Container(
    child: Center(
      child: Text("אם ברשותך תמונה של האבידה, צרפ/י אותה כאן.",
          style: TextStyle(fontSize: 16)),
    ),
  );
  bool _isAddLostLoading = false;

  @override
  void initState() {
    super.initState();
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
                child: widget.model.isLostLoading || _isAddLostLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildPageContent(),
              ),
            ));
          },
        ),
      ),
    );
  }

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

  Widget _currentPageContent() {
    switch (_pageTitle) {
      case "סוג האבידה":
        return _lostTypeContent();
        break;
      case "פרטים נוספים":
        return _moreDetailsContent();
        break;
      case "תמונה":
        return _addingPictureContent();
        break;
      case "מיקומים משוערים":
        return _possibleLocationsContent();
        break;
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
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _nameFormField(),
            _phoneNumberFormField(),
            _descriptionFormField(),
            _note()
          ],
        ),
      ),
    );
  }

  Widget _possibleLocationsContent() {
    List<String> lostFoundLocations = [];
    widget.model.LostFoundLocations.forEach((location) {
      lostFoundLocations.add(location.Number + " - " + location.Name);
    });
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      color: Color.fromRGBO(220, 250, 250, 0.7),
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _locationsScrollController,
        child: ListView(controller: _locationsScrollController, children: [
          CheckboxGroup(
            onSelected: (List<String> checked) => setState(() {
              _selOptionalLostLocations = checked;
            }),
            labels: lostFoundLocations,
            /*
            onChange: (bool isChecked, String label, int index) {
              _selOptionalLostLocations.add(label);
            },
            */
            itemBuilder: (Checkbox cb, Text txt, int i) {
              Text text = Text(
                txt.data,
                style: TextStyle(
                  fontSize: 15,
                ),
              );
              return Row(
                children: <Widget>[
                  cb,
                  text,
                ],
              );
            },
          )
        ]),
      ),
    );
  }

  void _pickImageFromGallery(ImageSource source) {
    setState(() {
      _futureImageFile = ImagePicker.pickImage(source: source);
    });
  }

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
                          _image = Container(
                            child: Center(
                              child: Text(
                                  "אם ברשותך תמונה של האבידה, צרפ/י אותה כאן.",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          );
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
            return Container(
              child: Center(
                child: Text("אם ברשותך תמונה של האבידה, צרפ/י אותה כאן.",
                    style: TextStyle(fontSize: 16)),
              ),
            );
        });
  }

  Widget _addingPictureContent() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(220, 250, 250, 0.7),
      child: Stack(
        children: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.add_photo_alternate),
            textColor: Colors.white,
            color: Colors.blue,
            label: Text("הוספת תמונה"),
            onPressed: () {
              _pickImageFromGallery(ImageSource.gallery);
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
            hintText: "תיאור האבידה וסימנים ייחודיים (לא חובה)",
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
                    _pageTitle = "סוג האבידה";
                    _nextButtonView(_pageTitle);
                    _isPreviousButtonVisible = false;
                    break;
                  case "מיקומים משוערים":
                    _pageTitle = "תמונה";
                    _nextButtonView(_pageTitle);
                    break;
                  case "תמונה":
                    _pageTitle = "פרטים נוספים";
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
                  case "סוג האבידה":
                    _pageTitle = "פרטים נוספים";
                    _nextButtonView(_pageTitle);
                    _isPreviousButtonVisible = true;
                    break;
                  case "פרטים נוספים":
                    if (_formKey.currentState.validate()) {
                      _pageTitle = "תמונה";
                    }
                    _nextButtonView(_pageTitle);
                    break;
                  case "תמונה":
                    _pageTitle = "מיקומים משוערים";
                    _nextButtonView(_pageTitle);
                    break;
                  case "מיקומים משוערים":
                    _addLostToDatabase();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  void _addLostToDatabase() async {
    if (_imageFile != null) {
      _isAddLostLoading = true;
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("lostImages");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(_imageFile);
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _imageUrl = ImageUrl.toString();
    }
    widget.model.addLost("lost", _selectedType, _name, _phoneNumber,
        _description, _selOptionalLostLocations, _imageUrl);
    _isAddLostLoading = false;
    Navigator.pop(context);
  }

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

  void _nextButtonView(String pageTitle) {
    switch (pageTitle) {
      case "סוג האבידה":
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
        if (_name.length >= 1 && _phoneNumber.length >= 1) {
          _nextButtonColor = Colors.blue;
          _isNextNotPressable = false;
        } else {
          _nextButtonColor = Colors.grey;
          _isNextNotPressable = true;
        }
        break;
      case "תמונה":
        _nextButtonText = "הבא";
        _nextButtonColor = Colors.blue;
        break;
      case "מיקומים משוערים":
        _nextButtonText = "סיום";
        _nextButtonColor = Colors.blue;
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
