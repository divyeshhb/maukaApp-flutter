// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mauka/screens/home_page.dart';
import 'package:mauka/screens/login_page.dart';
import 'package:mauka/services/authenticate.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? username;
  String? password;
  late FocusNode focusNode;
  bool isObscure = true;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 246, 255, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
                    radius: MediaQuery.of(context).size.width * 0.065,
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: Text(
                  'Create \nan account',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54),
                        color: Colors.white),
                    child: TextField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Email ID',
                        hintStyle: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
                      ),
                      onChanged: (val) {
                        username = val;
                      },
                      onSubmitted: (_) {
                        focusNode.requestFocus();
                      },
                      // autofocus: true,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54),
                        color: Colors.white),
                    child: TextField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        hoverColor: Colors.black,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusColor: Colors.black,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
                      ),
                      focusNode: focusNode,
                      obscureText: isObscure,
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Center(
                child: AnimatedButton(
                  onPressed: () {
                    if (username != null && password != null) {
                      if (password!.isNotEmpty && username!.isNotEmpty) {
                        //print('here');
                        Future response = Authenticate()
                            .addUser(username!, password!, context);
                        response.then((value) {
                          String token = jsonDecode(value.toString())['token'];
                          var storage = FlutterSecureStorage();
                          storage.write(key: "token", value: token);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }), (Route<dynamic> route) => false);
                        });
                      }
                    } else {
                      print('error');
                    }
                  },
                  height: MediaQuery.of(context).size.width / 6.5,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              })),
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
