// ignore_for_file: unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'utils/uti_class.dart';

class UpdateSeekerinfo extends StatefulWidget {
  const UpdateSeekerinfo({Key? key}) : super(key: key);

  @override
  State<UpdateSeekerinfo> createState() => _UpdateSeekerinfo();
}

class _UpdateSeekerinfo extends State<UpdateSeekerinfo> {
  final _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? contact;
  String? prof;
  String? expe;
  List<String> genders = ['Male', 'Female'];

  bool _isLoading = false;
  final _dateController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _contactController = TextEditingController();
  final _profController = TextEditingController();
  final _expController = TextEditingController();

  String? selectedgender;

  @override
  void dispose() {
    _dateController.dispose();
    _contactController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _profController.dispose();
    _expController.dispose();
    super.dispose();
  }

  Future<http.StreamedResponse?> edit(
      String seekerId,
      String firstName,
      String lastName,
      String dateOfbirth,
      String gender,
      String contact,
      String prof,
      String expe) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        dateOfbirth.isEmpty ||
        gender.isEmpty ||
        contact.isEmpty ||
        prof.isEmpty ||
        expe.isEmpty) {
      Fluttertoast.showToast(
        msg: "Some data are empty!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
      return null;
    } else {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}SeekerUpdateInfo.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'seekerid': seekerId,
        'password': UtilClass.prefs!.getString(UtilClass.pwKey)!,
        'username': UtilClass.prefs!.getString(UtilClass.unameKey)!,
        'firstname': firstName,
        'lastname': lastName,
        'dateofbirth': dateOfbirth,
        'gender': gender,
        'contact': contact,
        'profession': prof,
        'experience': expe
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response;
    }
  }

  Future<void> _editData(String firstName, String lastName, String dateOfbirth,
      String gender, String contact, String prof, String exp) async {
    try {
      // Make the POST request

      print(UtilClass.prefs!.getString(UtilClass.accountIdKey)! +
          firstName +
          lastName +
          dateOfbirth +
          gender +
          contact);
      final response = await edit(
          UtilClass.prefs!.getString(UtilClass.accountIdKey)!,
          firstName,
          lastName,
          dateOfbirth,
          gender,
          contact,
          prof,
          exp);

      if (response?.statusCode == 200) {
        dynamic data = await response?.stream.bytesToString();
        print(data);
        final result = json.decode(data);

        if (result[0]['success']) {
          UtilClass.updatePrefData(
              firstName, lastName, dateOfbirth, gender, contact, prof, exp);

          Future.delayed(const Duration(seconds: 2), () {
            Fluttertoast.showToast(
              msg: result[0]['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
            Navigator.pop(context, true);
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isLoading = false; // Hide loading indicator
              Fluttertoast.showToast(
                msg: result[0]['msg'],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[600],
                textColor: Colors.white,
              );
            });
          });
        }
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isLoading = false; // Hide loading indicator
            Fluttertoast.showToast(
              msg: "Connection Failed!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          });
        });
      }
    } catch (error) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _fnameController.text =
        UtilClass.prefs?.getString(UtilClass.fNameKey) ?? "";
    _lnameController.text =
        UtilClass.prefs?.getString(UtilClass.lNameKey) ?? "";
    _contactController.text =
        UtilClass.prefs?.getString(UtilClass.contactKey) ?? "";
    _dateController.text = UtilClass.prefs?.getString(UtilClass.bdayKey) ?? "";
    selectedgender = UtilClass.prefs?.getString(UtilClass.genderKey) ?? "";
    _expController.text = UtilClass.prefs?.getString(UtilClass.expKey) ?? "";
    _profController.text = UtilClass.prefs?.getString(UtilClass.profKey) ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Info'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(
                  heightFactor: 10, child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                        ),
                        controller: _fnameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstName = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                        ),
                        controller: _lnameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lastName = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                        ),
                        controller: _dateController,
                        onTap: () async {
                          final DateTime? dob = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (dob != null) {
                            dateOfBirth = dob.toIso8601String();

                            _dateController.text = DateFormat('yyyy-MM-dd')
                                .format(
                                    dob); // show selected date in the text field
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          dateOfBirth = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Contact number',
                        ),
                        controller: _contactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Contact number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          contact = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Put your Profession here (eg.Painter)',
                        ),
                        controller: _profController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Put your Profession here (eg.Painter)';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          prof = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText:
                              'Tell us about yor self here, A brief introduction of your experience',
                        ),
                        controller: _expController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tell us about yor self here, A brief introduction of your experience';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          expe = value;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                        ),
                        value: selectedgender,
                        onChanged: (String? newValue) {
                          selectedgender = newValue!;
                        },
                        items: genders
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select Gender';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          selectedgender = value;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true; // Show loading indicator
                              });

                              _formKey.currentState!.save();
                              //modify this to save in database
                              _editData(
                                  _fnameController.text,
                                  _lnameController.text,
                                  _dateController.text,
                                  selectedgender!,
                                  _contactController.text,
                                  _profController.text,
                                  _expController.text);
                            }
                          },
                          child: const Text('Save Edit'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
