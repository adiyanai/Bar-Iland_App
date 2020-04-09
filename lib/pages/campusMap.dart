
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class campusMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Bar Ilan Map"),
        ),
        body:
            PhotoView(
            imageProvider: AssetImage('assets/Bar_Ilan_Map.jpg')
          ),
      )
    );
  }
}
