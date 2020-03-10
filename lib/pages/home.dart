import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar-Iland'),
      ),
      body: Container(child: RaisedButton(color: Theme.of(context).primaryColor, child: Text('שירותים באוניברסיטה', style: TextStyle(fontSize: 15.0),),  onPressed: () {
            Navigator.pushReplacementNamed(context, '/service_manager');
          },)),
    );
  }
}