import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';

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

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], AuthMode.Login);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
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
        labelText: 'דוא"ל',
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
        labelText: 'סיסמה',
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

  Widget _buildConnectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return model.isLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'התחברות',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    textColor: Colors.white,
                    onPressed: () => _submitForm(model.authenticate),
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
                    color: Colors.black.withOpacity(0.80),
                  ),
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
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
                  _buildConnectionButtons(),
                  SizedBox(
                    height: 40.0,
                  ),
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
