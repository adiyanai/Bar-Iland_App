import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';
import '../models/connection.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AutoPageState();
  }
}

class _AutoPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  // submit form to login
  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    // login
    final Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], AuthMode.Login);
    // if the login successed go to the home page
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
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

  // build connection buttons
  Widget _buildConnectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // registered user connection button
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return model.isUserLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'התחברות',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    textColor: Colors.white,
                    // when pressed submit form to login
                    onPressed: () {
                      model.connectionMode = ConnectionMode.RegisteredUser;
                      _submitForm(model.authenticate);
                    },
                  );
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        // guest user connection button
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'כניסה כאורח/ת',
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              // when pressed go to the home page
              onPressed: () {
                model.connectionMode = ConnectionMode.GuestUser;
                Navigator.pushReplacementNamed(context, '/home');
              },
            );
          },
        ),
      ],
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
            'כניסה',
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
                    height: 10.0,
                  ),
                  // build password TextField
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  // build forget password button
                  Center(
                    child: FlatButton(
                      child: Text(
                        'שכחת סיסמה?',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.underline),
                      ),
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgetPassword');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // build connection buttons
                  _buildConnectionButtons(),
                  SizedBox(
                    height: 40.0,
                  ),
                  // build sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'אינך רשומ/ה?',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        child: Text(
                          'יצירת חשבון',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                      ),
                    ],
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
