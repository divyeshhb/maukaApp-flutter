// ignore_for_file: unused_import
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../strings.dart';

class CurrentUser {
  bool userExists = false;
  Future<List> checkToken(String token) async {
    dynamic res;
    await http.get(
      Uri.parse('${Strings.localhost}users/me'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    ).then((response) {
      if (response.statusCode == 200) {
        userExists = true;
        res = response.body;
      } else {
        userExists = false;
        res = response.body;
      }
    });
    return [
      userExists,
      res,
    ];
  }
}
