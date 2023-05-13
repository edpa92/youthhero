import 'package:flutter/material.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthhero/utils/uti_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
    UtilClass.prefs= await SharedPreferences.getInstance();
 
        final prefs = await SharedPreferences.getInstance();

        if (prefs.containsKey(UtilClass.isLogInKey) && prefs.getBool(UtilClass.isLogInKey)!) {          
          runApp(const MaterialApp(
            home: MyHomePage(),
          ));
        }else{
           runApp(const MaterialApp(
            home: LoginPage(),
          ));
        }
}
