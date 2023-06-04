import '../utils/uti_class.dart';
import 'package:http/http.dart' as http;

class SeekerModel {
  Future<http.StreamedResponse> getAllEducationOfSeeker(String seekrid) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var url = Uri.parse('${UtilClass.ipAddress}SeekerEducations.php');
    var request = http.Request('POST', url);
    request.bodyFields = {
      'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
      'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
      'seekerid': seekrid
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> addEducationOfSeeker(
      String seekrid, String educLevel, String major, String school) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var url = Uri.parse('${UtilClass.ipAddress}EducationAdd.php');
    var request = http.Request('POST', url);
    request.bodyFields = {
      'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
      'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
      'seekerid': seekrid,
      'educationlevel': educLevel,
      'majordegree': major,
      'school': school
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> deleteEducationOfSeeker(String educid) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var url = Uri.parse('${UtilClass.ipAddress}EducationDelete.php');
    var request = http.Request('POST', url);
    request.bodyFields = {
      'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
      'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
      'educationid': educid,
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return response;
  }
}
