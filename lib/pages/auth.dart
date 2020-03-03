import 'package:flutter/material.dart';
import './home.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AutoPageState();
  }
}

class _AutoPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;

  Widget _buildUserNameTextField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'שם משתמש:',
          filled: true,
          fillColor: Colors.white70,
        ),
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.right,
        onChanged: ((String value) {
          setState(() {
            _emailValue = value;
          });
        }),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'סיסמה:',
          filled: true,
          fillColor: Colors.white70,
        ),
        obscureText: true,
        textAlign: TextAlign.right,
        onChanged: ((String value) {
          setState(() {
            _passwordValue = value;
          });
        }),
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
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
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
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.55), BlendMode.dstATop),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: <Widget>[
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
                    decoration: TextDecoration.underline
                  ),
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
