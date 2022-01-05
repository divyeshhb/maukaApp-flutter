// ignore_for_file: unused_import
// ignore_for_file: use_rethrow_when_possible
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: avoid_print
// ignore_for_file: unused_local_variable
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../strings.dart';
import 'current_user.dart';

class Authenticate {
  Dio dio = Dio();

  Future authentication(String username, String password, context) async {
    try {
      Response response = await dio.post(
        '${Strings.localhost}users/login',
        data: jsonEncode({
          'email': username,
          'password': password,
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      return response;
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        print('Wrong email or password');
      }
      throw err;
    }
  }

  Future addUser(String username, String password, context) async {
    try {
      Response response = await dio.post(
        '${Strings.localhost}users/signup',
        data: {
          'email': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      return response;
      //print(token);
    } on DioError catch (err) {
      print(err.response?.data);
      throw err;
    }
  }

  logout(String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post(
        '${Strings.localhost}users/logout',
        options: Options(
          contentType: Headers.wwwAuthenticateHeader,
        ),
      );
      var storage = const FlutterSecureStorage();
      var options = const IOSOptions(
        accessibility: IOSAccessibility.first_unlock,
      );
      await storage.delete(key: 'token');
    } on DioError catch (err) {
      print(err.response?.data);
      throw err;
    }
  }

  feedback(
      String token, String course, String user, String data, context) async {
    try {
      //print('here');
      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post(
        '${Strings.localhost}users/feedback',
        data: jsonEncode({
          'topic': course,
          'username': user,
          'feedback': data,
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      //print(response);
      //return response;
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        print("Couldn't do it");
      }
      throw err;
    }
  }

  reflect(String token, String answer1, String answer2, context) async {
    try {
      //print('here');
      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post(
        '${Strings.localhost}users/reflect',
        data: jsonEncode({
          'question1': answer1,
          'question2': answer2,
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      print(response);
      //return response;
    } on DioError catch (err) {
      if (err.response?.statusCode == 400) {
        print("Couldn't do it");
      }
      throw err;
    }
  }
}
