import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilClass {
  static const String ipAddress = "http://192.168.43.177/youthheroapi/";
  static const String isLogInKey = "IsLogInKey";
  static const String unameKey = "UnameKey";
  static const String pwKey = "PWKey";
  static const String displayNameKey = "DisplayNameKey";
  static const String fNameKey = "fNameKey";
  static const String lNameKey = "lNameKey";
  static const String uidKey = "uidKey";
  static const String accountIdKey = "accountIdKey";
  static const String isSeekerKey = "isSeekerKey";
  static const String genderKey = "genderKey";
  static const String bdayKey = "bdayKey";
  static const String contactKey = "contactKey";
  static const String profilePicKey = "profilePicKey";
  static const String profKey = "profKey";
  static const String expKey = "expKey";
  static SharedPreferences? prefs;

  static Future<void> updatePrefData(
      String firstName,
      String lastName,
      String dateOfbirth,
      String gender,
      String contact,
      String prof,
      String exp) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(UtilClass.displayNameKey, "$firstName $lastName");
    await prefs.setString(UtilClass.fNameKey, firstName);
    await prefs.setString(UtilClass.lNameKey, lastName);
    await prefs.setString(UtilClass.genderKey, gender);
    await prefs.setString(UtilClass.bdayKey, dateOfbirth);
    await prefs.setString(UtilClass.contactKey, contact);
    await prefs.setString(UtilClass.profKey, prof);
    await prefs.setString(UtilClass.expKey, exp);
  }

  static ImageProvider<Object> generateImageFromBase64(String base64Pic) {
    Uint8List bytes = base64Decode(base64Pic);
    return Image.memory(bytes).image;
  }

  static ImageProvider<Object> geProfilePic() {
    Uint8List bytes =
        base64Decode(prefs?.getString(UtilClass.profilePicKey) ?? "");
    return Image.memory(bytes).image;
  }
}
