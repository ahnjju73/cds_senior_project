import 'dart:convert';

import 'package:cds_class/account/model/User.dart';
import 'package:http/http.dart' as http;

// const baseUrl = 'http://43.203.230.76:8080';
const baseUrl = 'http://127.0.0.1:8080';
final headers = {
  'Content-Type' : 'application/json',
  'Accept' : 'application/json'
};

class ApiClient{
  final http.Client httpClient;
  
  ApiClient({required this.httpClient});
  
  // getUser(String email) async{
  //   var response = await httpClient.get(Uri.parse(baseUrl + ''))
  // }

  static Future<dynamic> joinUser(User user) async{
    var response = await http.post(Uri.parse(baseUrl + '/joinus'),
      body: json.encode(user.toJson()),
    );
    return response;
  }

}


