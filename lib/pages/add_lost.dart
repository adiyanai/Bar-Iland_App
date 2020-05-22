import 'package:flutter/material.dart';
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
  String _selLostType = "";
  String _pageTitle = "סוג האבידה";
  Color _nextButtonColor = Colors.grey;
  String _selLostFoundDescription = "";

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
      _currentPageContent(),
      Container(
        padding: EdgeInsets.only(top: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
            SizedBox(width: MediaQuery.of(context).size.height / 15.0),
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
                      _pageTitle = "תיאור האבידה (לא חובה)";
                  }
                });
              },
            ),
          ],
        ),
      )
    ]);
  }

  Widget _currentPageContent() {
    switch (_pageTitle) {
      case "סוג האבידה":
        return Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 60),
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _typesScrollController,
            child: ListView(controller: _typesScrollController, children: [
              Container(
                color: Color.fromRGBO(220, 250, 250, 0.7),
                child: RadioButtonGroup(
                  padding: EdgeInsets.only(right: 0),
                  labels: widget.model.LostFoundTypes,
                  onSelected: (String selected) => {
                    setState(() {
                      _selLostType = selected;
                      _nextButtonColor = Colors.blue;
                    })
                  },
                ),
              )
            ]),
          ),
        );
        break;
      case "תיאור האבידה (לא חובה)":
        return Container(
          height: 250,
          color: Color.fromRGBO(220, 250, 250, 0.7),
          margin:
              EdgeInsets.only(top: 20),
          child: Center(child: TextField(
            autofocus: false,
            decoration:
                new InputDecoration(hintText: "תיאור כללי וסימנים ייחודיים"),
            onChanged: (value) {
              _selLostFoundDescription = value;
            },
          ),
        ));
      default:
        return Container();
    }
  }
}
