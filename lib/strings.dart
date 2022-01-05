import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Strings {
  static String localhost1 = 'http://10.0.2.2:3000/';
  static String localhost2 = 'http://127.0.0.1:3000/';
  static String localhost = 'https://mauka-app.herokuapp.com/';

  String? userToken;

  getToken() async {
    var storage = const FlutterSecureStorage();
    const options = IOSOptions(
      accessibility: IOSAccessibility.first_unlock,
    );
    userToken = await storage.read(key: "token", iOptions: options);
    return userToken;
  }
}
