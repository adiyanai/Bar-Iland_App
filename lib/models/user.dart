import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String token;

  User({@required this.id, @required this.email, @required this.token});

  String get ID {
    return id;
  }

  String get Email {
    return email;
  }

  String get Token {
    return token;
  }
}
