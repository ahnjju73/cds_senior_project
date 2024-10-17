import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveData(String key, SaveData user) async {
  final prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson());  // 객체를 JSON으로 변환
  await prefs.setString('$key', userJson);  // JSON 문자열을 저장
}

// 객체를 불러오는 함수
Future<SaveData?> loadData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('$key');

  if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return SaveData.fromJson(userMap);  // JSON 문자열을 객체로 변환
  }
  return null;
}

class SaveData{
  String name;
  String b1Course;
  String b1Class;
  String b2Course;
  String b2Class;
  String b3Course;
  String b3Class;
  String b4Course;
  String b4Class;
  String b5Course;
  String b5Class;
  String b6Course;
  String b6Class;
  String b7Course;
  String b7Class;


  SaveData(
      this.name,
      this.b1Course,
      this.b1Class,
      this.b2Course,
      this.b2Class,
      this.b3Course,
      this.b3Class,
      this.b4Course,
      this.b4Class,
      this.b5Course,
      this.b5Class,
      this.b6Course,
      this.b6Class,
      this.b7Course,
      this.b7Class,
      );

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'b1Course': b1Course,
      'b1Class': b1Class,
      'b2Course': b2Course,
      'b2Class': b2Class,
      'b3Course': b3Course,
      'b3Class': b3Class,
      'b4Course': b4Course,
      'b4Class': b4Class,
      'b5Course': b5Course,
      'b5Class': b5Class,
      'b6Course': b6Course,
      'b6Class': b6Class,
      'b7Course': b7Course,
      'b7Class': b7Class,
    };
  }

  // JSON에서 객체로 변환
  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData(
      json['name'],
      json['b1Course'],
      json['b1Class'],
      json['b2Course'],
      json['b2Class'],
      json['b3Course'],
      json['b3Class'],
      json['b4Course'],
      json['b4Class'],
      json['b5Course'],
      json['b5Class'],
      json['b6Course'],
      json['b6Class'],
      json['b7Course'],
      json['b7Class'],
    );
  }
}