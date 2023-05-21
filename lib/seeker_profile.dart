import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youthhero/recruitersignup.dart';
import 'package:youthhero/seeker_update_profile.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() => runApp(const SeekerProfilePage());

var displayName = "";
var profession = "";
var info = "";
var exp = "";
var pic = "";

class SeekerProfilePage extends StatefulWidget {
  const SeekerProfilePage({super.key});

  @override
  State<SeekerProfilePage> createState() => _SeekerProfilePage();
}

class _SeekerProfilePage extends State<SeekerProfilePage> {
  bool _isLoading = false;
  bool _uploadSuccess = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    _getDatFromPref();
  }

  void _getDatFromPref() {
    displayName = UtilClass.prefs!.getString(UtilClass.displayNameKey)!;
    profession = UtilClass.prefs!.getString(UtilClass.profKey)!;
    info =
        "${UtilClass.prefs!.getString(UtilClass.genderKey)} ${UtilClass.prefs!.getString(UtilClass.contactKey)} ${UtilClass.prefs!.getString(UtilClass.bdayKey)}";
    exp = UtilClass.prefs!.getString(UtilClass.expKey)!;
    pic = UtilClass.prefs!.getString(UtilClass.profilePicKey)!;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        _image = File(pickedImage.path);
        final response =
            await uploadImage(_image!, path.extension(pickedImage.path));

        if (response.statusCode == 200) {
          dynamic data = await response.stream.bytesToString();
          print(data);
          final result = json.decode(data);

          if (result[0]['success']) {
            String newbase64Pic =
                base64Encode(_image?.readAsBytesSync() as List<int>);
            UtilClass.prefs?.setString(UtilClass.profilePicKey, newbase64Pic);
            setState(() async {
              _isLoading = false;
              _uploadSuccess = true;
            });
            Fluttertoast.showToast(
              msg: result[0]['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          } else {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              msg: result[0]['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          }
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isLoading = false;
            }); // Hide loading indicator
            Fluttertoast.showToast(
              msg: "Connection Error!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          });
        }
      } catch (error) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isLoading = false;
          });
          print(error.toString()); // Hide loading indicator
        });
      }
    }
  }

  Future<http.StreamedResponse> uploadImage(File imageFile, String ext) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${UtilClass.ipAddress}SeekerUpdatePhoto.php'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['username'] =
        UtilClass.prefs!.getString(UtilClass.unameKey)!;
    request.fields['password'] = UtilClass.prefs!.getString(UtilClass.pwKey)!;
    request.fields['seekerid'] =
        UtilClass.prefs!.getString(UtilClass.accountIdKey)!;
    request.fields['ext'] = ext;

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadSuccess) {
      Navigator.pop(context);
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _isLoading
            ? const Center(heightFactor: 10, child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: (_image != null && _uploadSuccess)
                            ? FileImage(_image!)
                            : UtilClass.generateImageFromBase64(pic),
                        child: _image == null && pic.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 80,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        profession,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'About Me',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        info,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        exp,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Skills',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        children: const [
                          Chip(label: Text('Flutter')),
                          Chip(label: Text('Dart')),
                          Chip(label: Text('Firebase')),
                          Chip(label: Text('UI/UX Design')),
                          Chip(label: Text('Problem Solving')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        appBar: AppBar(title: const Text('Your Profile')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.upload_file), // Add the desired icon here
                          label: const Text('Change Profile Picture'),
                          onPressed: () async {
                            _pickImage();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.edit), // Add the desired icon here
                          label: const Text('Update Information'),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateSeekerinfo()),
                            );
                            if (result ?? false) {
                              _getDatFromPref();
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.school), // Add the desired icon here
                          label: const Text('Add Education'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecruiterRegForm()),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.build), // Add the desired icon here
                          label: const Text('Add Skill(S)'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecruiterRegForm()),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.key), // Add the desired icon here
                          label: const Text('Update Security Info'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecruiterRegForm()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.edit),
        ),
      ),
      color: Colors.white,
    );
  }
}
