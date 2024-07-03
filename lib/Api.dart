import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class API{
  static const String url = "http://192.168.8.102:8092";
  static String jwt = '';

  static Future<bool> login(String username, String password) async {
    final response = await http.post(Uri.parse('$url/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': username, 'password': password}));
      var body = json.decode(response.body);
      if (body['status'] == 'success') {
        jwt = body['token']; // save auth token
        print(jwt);
        return true;
      }
      else {
        return false;
      }
  }

  static Future<bool> logout() async {
    API.jwt = null;
    jwt = null;
    return true;
  }

  static Future<dynamic> getSleepStatistics() async {
    final queryParameters = {
      'fromdate': '2021-12-02 00:00:00',
      'todate': '2021-12-02 01:18:12',
    };
    final uri =
    Uri.http('192.168.8.102:8090', '/sleepdata', queryParameters);
    final response = await http.get(uri, headers: {
    HttpHeaders.authorizationHeader: "Bearer $jwt"
    },);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
    else return null;
  }

  static Future<String> getSleepStatisticsForSelectedUser(String jwt) async {

    var response = await http.get(Uri.parse(url + "/user_sleep"), headers: {
      HttpHeaders.authorizationHeader: jwt,
    },);
    return response.body;
  }

  static Future<dynamic> getChallenges() async {
    var response = await http.get(Uri.parse('http://192.168.8.102:8090/challenge'), headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
    });
    var body = json.decode(response.body);
    return body;

  }
}