import 'package:shared_preferences/shared_preferences.dart';

class UtilClass {
  static const String ipAddress = "http://192.168.43.177/youthheroapi/";
  static const String isLogInKey = "IsLogInKey";
  static const String unameKey = "UnameKey";
  static const String pwKey = "PWKey";
  static const String displayNameKey = "DisplayNameKey";
  static const String uidKey = "uidKey";
  static const String accountIdKey = "accountIdKey";
  static const String isSeekerKey = "isSeekerKey";
  static SharedPreferences? prefs;
}
