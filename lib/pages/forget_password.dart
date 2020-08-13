import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordState();
  }
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = null;

  // submit form to reset password
  void _submitForm(Function resetPassword) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    // reset password
    final Map<String, dynamic> successInformation = await resetPassword(_email);
    // if the reset successed go to the auth page
    if (successInformation['success']) {
      Navigator.pop(context);
    // else show an alert dialog
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('אירעה שגיאה'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('אישור'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // build the background image
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.55),
        BlendMode.dstATop,
      ),
    );
  }

  // build email TextField
  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'דוא"ל',
        suffixIcon: Icon(Icons.email),
        filled: true,
        fillColor: Colors.white70,
      ),
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.right,
      // check the validity of the email
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'דוא"ל לא תקין';
        }
      },
      // save the email the user typed
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'שחזור סיסמה',
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            // build the background image
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Image.asset(
                    'assets/Bar_Iland_line.png',
                    height: 200,
                    color: Colors.black.withOpacity(0.80),
                  ),
                  // build email TextField
                  _buildEmailTextField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  // reset password button
                  ScopedModelDescendant<MainModel>(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return model.isUserLoading
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'שחזור',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                textColor: Colors.white,
                                // when pressed submit form to reset password
                                onPressed: () {
                                  _submitForm(model.resetPassword);
                                },
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
