import 'package:flutter/material.dart';

class Degree {
  String id;
  final String degreeType;
  final String name;
  final String url;
  List<Degree> sameTypeDegreese = [];

  Degree({@required this.id, @required this.degreeType, @required this.name ,@required this.url});
  
  String get ID {
    return id;
  }

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

