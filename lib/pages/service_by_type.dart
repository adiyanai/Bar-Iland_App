import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';

class ServiceByType extends StatelessWidget {
  final MainModel model;
  ServiceByType(this.model);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("All Services!"));
  }
}
