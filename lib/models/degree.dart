import 'package:flutter/material.dart';

class Degree {
  final String id;
  final String degreeType;
  final String name;
  final String url;

  Degree({@required this.id, @required this.degreeType, @required this.name ,@required this.url});

  String get DegreeType {
    return degreeType;
  }

  String get Name {
    return name;
  }

  String get Url {
    return url;
  }
}

