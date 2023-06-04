import 'package:flutter/material.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthhero/utils/uti_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UtilClass.prefs = await SharedPreferences.getInstance();

  if ((UtilClass.prefs?.containsKey(UtilClass.isLogInKey) ?? false) &&
      (UtilClass.prefs?.getBool(UtilClass.isLogInKey) ?? false)) {
    runApp(const MaterialApp(
      home: MyhomePage(),
    ));
  } else {
    runApp(const MaterialApp(
      home: LoginPage(),
    ));
  }
}
