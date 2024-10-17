import 'dart:convert';

import 'package:crypto/crypto.dart';

class User{
  var email;
  var name;
  var password;
  var house;
  var grade;

  User({required this.email, required this.name, required this.password, required this.house, required this.grade});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        email: json['email'],
        name: json['name'],
        password: json['password'],
        house: json['house'],
        grade: json['grade']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'email' : email,
      'name' : name,
      'password' : sha256.convert(utf8.encode(password)).toString(),
      'house' : house,
      'grade' : grade,
    };
  }

}