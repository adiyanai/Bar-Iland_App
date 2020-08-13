import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  // submit form to signup
  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    // signup
    final Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], AuthMode.SignUp);
    // if the signup successed go back to the auth page
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
            !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                .hasMatch(value)) {
          return 'דוא"ל לא תקין';
        }
      },
      // save the email the user typed
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  // build password TextField
  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'סיסמה',
        suffixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white70,
      ),
      controller: _passwordTextController,
      obscureText: true,
      textAlign: TextAlign.right,
      // check the validity of the password
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'סיסמה לא תקינה';
        }
      },
      // save the password the user typed
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  // build confirm password TextField
  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'אימות סיסמה',
        suffixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white70,
      ),
      obscureText: true,
      textAlign: TextAlign.right,
      // check that the confirm password equals to the password
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'הסיסמאות אינן תואמות';
        }
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
            'הרשמה',
          ),
        ),
        body: Container(
          // build the background image
          decoration: BoxDecoration(
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
                    height: 10.0,
                  ),
                  // build password TextField
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  // build confirm password TextField
                  _buildConfirmPasswordTextField(),
                  SizedBox(
                    height: 50.0,
                  ),
                  // build end signup button
                  ScopedModelDescendant<MainModel>(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return model.isUserLoading
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'סיום הרשמה',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                textColor: Colors.white,
                                // when pressed submit form to signup
                                onPressed: () =>
                                    _submitForm(model.authenticate),
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
