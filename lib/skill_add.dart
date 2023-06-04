import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:youthhero/utils/uti_class.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

void main() => runApp(const AddSkillPage());

final List<String> suggestions = [];
final List<String> suggestionsId = [];

final List<String> savedList = [];
final List<String> savedListId = [];

String selectedId = "";
var _isLoading = false;

class AddSkillPage extends StatefulWidget {
  const AddSkillPage({super.key});

  @override
  State<AddSkillPage> createState() => _AddSkillPage();
}

class _AddSkillPage extends State<AddSkillPage> {
  final _descController = TextEditingController();

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
          savedList.clear();

          for (var i = 0; i < skillsList.length; i++) {
            savedList.add(skillsList[i]['skill']);
            savedListId.add(skillsList[i]['skillid']);
          }
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

  Future<void> addSeekerSkillSet(
      String seekerid, String skillid, String skillDescription) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}SeekerSkillAdd.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
        'seekerid': seekerid,
        'skillid': skillid,
        'skill': skillDescription,
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);
        if (result[0]['success']) {
          savedList.add(skillDescription);
          savedListId.add(result[0]['skillid'].toString());
        }

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

  Future<void> getAllNotSkillsOfSeeker(String seekerid) async {
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
        'not': "true",
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);
        if (result[0]['success']) {
          var skillsList = result[0]['skills'];
          suggestions.clear();

          for (var i = 0; i < skillsList.length; i++) {
            suggestions.add(skillsList[i]['skill']);
            suggestionsId.add(skillsList[i]['skillid'].toString());
          }
          setState(() {
            _isLoading = false;
          });
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
  }

  @override
  void initState() {
    super.initState();
    getAllSeekerSkill(UtilClass.prefs?.getString(UtilClass.accountIdKey) ?? "");
    getAllNotSkillsOfSeeker(
        UtilClass.prefs?.getString(UtilClass.accountIdKey) ?? "");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Skills'),
        ),
        body: _isLoading
            ? const Center(heightFactor: 10, child: CircularProgressIndicator())
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(16),
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              decoration: const InputDecoration(
                                labelText: 'Enter your Skill',
                                border: OutlineInputBorder(),
                              ),
                              controller: _descController),
                          suggestionsCallback: (pattern) async {
                            return suggestions.where((item) => item
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            final index = suggestions.indexOf(suggestion);
                            final suggId = suggestionsId.elementAt(index);
                            selectedId = suggId;
                            setState(() {
                              savedList.add(suggestion);
                              savedListId.add(suggId);
                              addSeekerSkillSet(
                                  UtilClass.prefs
                                          ?.getString(UtilClass.accountIdKey) ??
                                      "",
                                  suggId,
                                  "");
                            });
                          },
                        ),
                      )),
                      ElevatedButton(
                        onPressed: () {
                          if (_descController.text.isNotEmpty) {
                            setState(() {
                              _isLoading = true; // Show loading indicator
                              addSeekerSkillSet(
                                  UtilClass.prefs
                                          ?.getString(UtilClass.accountIdKey) ??
                                      "",
                                  "",
                                  _descController.text);
                              _descController.text = "";
                            });
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ]),
                Expanded(
                  child: ListView.builder(
                    itemCount: savedList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(savedList[index]),
                      );
                    },
                  ),
                )
              ]));
  }
}
