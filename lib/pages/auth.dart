import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../scoped-models/main.dart';

enum AuthMode { SignUp, Login }

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
  AuthMode _authMode = AuthMode.Login;

  void _submitForm(Function login) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/home');
  }

  DecorationImage _buildBackgroungImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.55),
        BlendMode.dstATop,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'דוא"ל:',
        suffixIcon: Icon(Icons.email),
        filled: true,
        fillColor: Colors.white70,
      ),
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.right,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'הכנס כתובת דוא"ל תקינה';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'סיסמה:',
        suffixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white70,
      ),
      controller: _passwordTextController,
      obscureText: true,
      textAlign: TextAlign.right,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'סיסמה לא תקינה';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'אימות סיסמה:',
        suffixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white70,
      ),
      obscureText: true,
      textAlign: TextAlign.right,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'הסיסמאות אינן תואמות';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConnectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'התחברות',
                style: TextStyle(fontSize: 20.0),
              ),
              textColor: Colors.white,
              onPressed: () => _submitForm(model.login),
            );
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'כניסה כאורח/ת',
            style: TextStyle(fontSize: 15.0),
          ),
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
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
          title: Text(
            'כניסה',
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: _buildBackgroungImage(),
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
                  ),
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _authMode == AuthMode.SignUp
                      ? _buildPasswordConfirmTextField()
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _authMode == AuthMode.Login
                      ? FlatButton(
                          child: Text(
                            'שכחת סיסמה?',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline),
                          ),
                          textColor: Colors.black,
                          onPressed: () {},
                        )
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _authMode == AuthMode.Login
                      ? _buildConnectionButtons()
                      : Container(),
                  SizedBox(
                    height: 40.0,
                  ),
                  _authMode == AuthMode.Login
                      ? Row(
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
                                setState(() {
                                  _authMode = _authMode == AuthMode.Login
                                      ? AuthMode.SignUp
                                      : AuthMode.Login;
                                });
                              },
                            ),
                          ],
                        )
                      : Container(),
                  _authMode == AuthMode.SignUp
                      ? RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'סיים הרשמה',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            setState(() {
                              _authMode = _authMode == AuthMode.Login
                                  ? AuthMode.SignUp
                                  : AuthMode.Login;
                            });
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
