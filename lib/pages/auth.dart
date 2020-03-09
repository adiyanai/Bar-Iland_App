import 'package:flutter/material.dart';
import './home.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AutoPageState();
  }
}

class _AutoPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Widget _buildUserNameTextField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'דוא"ל:',
          filled: true,
          fillColor: Colors.white70,
        ),
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.right,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'בבקשה הכנס כתובת דוא"ל תקינה';
          }
          return '';
        },
        onSaved: (String value) {
          _formData['email'] = value;
        },
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'סיסמה:',
          filled: true,
          fillColor: Colors.white70,
        ),
        obscureText: true,
        textAlign: TextAlign.right,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return 'סיסמה לא תקינה';
          }
          return '';
        },
        onSaved: (String value) {
          _formData['password'] = value;
        },
      ),
    );
  }

  Widget _buildConnectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
        SizedBox(
          width: 10.0,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'התחברות',
            style: TextStyle(fontSize: 20.0),
          ),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.login),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
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
          child: ListView(
            children: <Widget>[
              CircleAvatar(),
              Image.asset(
                'assets/Bar_Iland_line.png',
                height: 200,
              ),
              _buildUserNameTextField(),
              SizedBox(
                height: 10.0,
              ),
              _buildPasswordTextField(),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                child: Text(
                  '?שכחת סיסמה',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline),
                ),
                textColor: Colors.black, //Theme.of(context).primaryColor,
                onPressed: () {},
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildConnectionButtons(),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    //color: ,
                    child: Text(
                      'יצירת חשבון',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    //textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '?אינך רשומ/ה',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
