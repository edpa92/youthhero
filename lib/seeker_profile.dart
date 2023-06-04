import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youthhero/recruitersignup.dart';
import 'package:youthhero/seeker_update_profile.dart';
import 'package:youthhero/skill_add.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:youthhero/model/seeker_model.dart';

void main() => runApp(const SeekerProfilePage());

var displayName = "";
var profession = "";
var info = "";
var exp = "";
var pic = "";
var edu = "";

class SeekerProfilePage extends StatefulWidget {
  const SeekerProfilePage({super.key});

  @override
  State<SeekerProfilePage> createState() => _SeekerProfilePage();
}

class _SeekerProfilePage extends State<SeekerProfilePage> {
  bool _isLoading = false;
  bool _uploadSuccess = false;
  File? _image;

  final _formKey = GlobalKey<FormState>();

  String? education;
  List<String> educaionsLevel = [
    'Graduate School',
    'College/University',
    'Sr High School',
    'JR High School',
    'Vocational Course ',
    'Elementary'
  ];

  var educaionsList = <String>[];
  var educaionids = <String>[];

  final _eduController = TextEditingController();
  final _majorController = TextEditingController();
  final _schoolController = TextEditingController();
  List<String> chipData = [];
  List<String> chipDataId = [];
  List<Widget> chipWidgets = [];

  String? selectededu;
  String? school;
  String? major;

  @override
  void dispose() {
    super.dispose();
    _eduController.dispose();
    _majorController.dispose();
    _schoolController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getDatFromPref();
    getAllSeekerSkill(UtilClass.prefs?.getString(UtilClass.accountIdKey) ?? "");
  }

  void _getDatFromPref() {
    displayName = UtilClass.prefs!.getString(UtilClass.displayNameKey)!;
    profession = UtilClass.prefs!.getString(UtilClass.profKey)!;
    info =
        "${UtilClass.prefs!.getString(UtilClass.genderKey)} ${UtilClass.prefs!.getString(UtilClass.contactKey)} ${UtilClass.prefs!.getString(UtilClass.bdayKey)}";
    exp = UtilClass.prefs!.getString(UtilClass.expKey)!;
    pic = UtilClass.prefs!.getString(UtilClass.profilePicKey)!;
    getAllEducs();
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

  Future<String> getAllEducs() async {
    _isLoading = true;
    edu = "";
    try {
      final responseEducs = await SeekerModel().getAllEducationOfSeeker(
          UtilClass.prefs?.getString(UtilClass.accountIdKey) ?? "0");

      if (responseEducs.statusCode == 200) {
        dynamic data = await responseEducs.stream.bytesToString();
        print(data);
        final result = json.decode(data);
        if (result[0]['success']) {
          var educsList = result[0]['educs'];
          educaionsList.clear();
          educaionids.clear();

          for (var i = 0; i < educsList.length; i++) {
            var data = result[0]['educs'][i];
            edu += data['educationlevel'] +
                " | " +
                data['majordegree'] +
                " | " +
                data['school'] +
                "\n\n";

            educaionsList.add(data['educationlevel'] +
                " | " +
                data['majordegree'] +
                " | " +
                data['school']);
            educaionids.add(data['educationid']);
          }
          setState(() {
            _isLoading = false;
          });
          return edu;
        } else {
          Fluttertoast.showToast(
            msg: result[0]['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[600],
            textColor: Colors.white,
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Connection Error!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
    }
    return "";
  }

  Future<void> addEducs(String educLevel, String major, String school) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final responseEducs = await SeekerModel().addEducationOfSeeker(
          UtilClass.prefs?.getString(UtilClass.accountIdKey) ?? "0",
          educLevel,
          major,
          school);

      if (responseEducs.statusCode == 200) {
        dynamic data = await responseEducs.stream.bytesToString();
        final result = json.decode(data);
        if (result[0]['success']) {
          setState(() {
            getAllEducs();

            Fluttertoast.showToast(
              msg: "Education added",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Connection Error!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
    }
  }

  Future<void> getAllSeekerSkill(String seekerid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}SeekerSkills.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
        'seekerid': seekerid,
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);
        if (result[0]['success']) {
          var skillsList = result[0]['skills'];
          chipData.clear();

          for (var i = 0; i < skillsList.length; i++) {
            chipData.add(skillsList[i]['skill']);
            chipDataId.add(skillsList[i]['skillid']);
          }

          generateChips();
        }
      } else {
        Fluttertoast.showToast(
          msg: "Connection Error!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
    }
  }

  Future<void> deleteSeekerSkill(String seekerid, String skillid) async {
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}SeekerSkillDelete.php');
      var request = http.Request('POST', url);

      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
        'seekerid': seekerid,
        'skillid': skillid
      };

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);
        if (result[0]['success']) {}
      } else {
        Fluttertoast.showToast(
          msg: "Connection Error!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
    }
  }

  void generateChips() {
    chipWidgets = chipData.map((data) {
      return Chip(
        label: Text(data),
        onDeleted: () {
          int index = chipData.indexOf(data);
          setState(() {
            deleteSeekerSkill(
                UtilClass.prefs?.getString(UtilClass.accountIdKey) ?? "",
                chipDataId[index]);
            chipData.remove(data);
            chipDataId.removeAt(index);

            generateChips();
          });
        },
      );
    }).toList();
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
                            : UtilClass.base64ToImage(pic),
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
                        spacing: 5.0,
                        children: chipWidgets,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Education',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        edu,
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
                              setState(() {
                                Navigator.pop(context);
                              });
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
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Form(
                                    key: _formKey,
                                    child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              DropdownButtonFormField<String>(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Education level',
                                                ),
                                                value: selectededu,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectededu = newValue!;
                                                  });
                                                },
                                                items: educaionsLevel.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select Education level';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  selectededu = value;
                                                },
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Major/Degree (optional)',
                                                ),
                                                controller: _majorController,
                                                onSaved: (value) {
                                                  major = value;
                                                },
                                              ),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Name of School',
                                                ),
                                                controller: _schoolController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter your School name';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  school = value;
                                                },
                                              ),
                                              const SizedBox(height: 24.0),
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      //modify this to save in database
                                                      Navigator.pop(context);
                                                      addEducs(
                                                          selectededu!,
                                                          _majorController.text,
                                                          _schoolController
                                                              .text);
                                                    }
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ),
                                            ])),
                                  );
                                });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.delete), // Add the desired icon here
                          label: const Text('Delete Education'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Educations'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: educaionsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(educaionsList[index]),
                                            trailing: ElevatedButton.icon(
                                              icon: const Icon(Icons
                                                  .delete), // Add the desired icon here
                                              label: const Text(''),
                                              onPressed: () async {
                                                print("Education Deleting");
                                                try {
                                                  final responseDeleteEduc =
                                                      await SeekerModel()
                                                          .deleteEducationOfSeeker(
                                                              educaionids[
                                                                  index]);
                                                  if (responseDeleteEduc
                                                          .statusCode ==
                                                      200) {
                                                    print(
                                                        "Education Deleting Connection OK");
                                                    dynamic data =
                                                        await responseDeleteEduc
                                                            .stream
                                                            .bytesToString();
                                                    final result =
                                                        json.decode(data);
                                                    print(result);
                                                    if (result[0]['success']) {
                                                      setState(() {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "Education Deleted",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.grey[600],
                                                          textColor:
                                                              Colors.white,
                                                        );
                                                        getAllEducs();
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: result[0]['msg'],
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.grey[600],
                                                        textColor: Colors.white,
                                                      );
                                                    }
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: "Connection Error!",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey[600],
                                                      textColor: Colors.white,
                                                    );
                                                  }
                                                } catch (e) {
                                                  Fluttertoast.showToast(
                                                    msg: e.toString(),
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.grey[600],
                                                    textColor: Colors.white,
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                });
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
                                  builder: (context) => AddSkillPage()),
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
