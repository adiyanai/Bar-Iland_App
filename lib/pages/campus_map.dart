import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CampusMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Center(child: Text('מפת הקמפוס')),
          ),
          body: PhotoView(
            imageProvider: AssetImage('assets/Bar_Ilan_Map.jpg'),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4.8,
            initialScale: PhotoViewComputedScale.contained,
          ),
        ));
  }
}