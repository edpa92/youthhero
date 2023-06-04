// ignore_for_file: unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youthhero/login.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'utils/uti_class.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? education;
  String? major;
  String? school;
  String? gender;
  String? contact;
  String? email;
  String? password1;
  String? password2;
  List<String> genders = ['Male', 'Female'];
  List<String> educaions = [
    'Graduate School',
    'College/University',
    'Sr High School',
    'JR High School',
    'Vocational Course ',
    'Elementary'
  ];

  bool _isLoading = false;
  final _dateController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _eduController = TextEditingController();
  final _majorController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _schoolController = TextEditingController();

  String? selectedgender;
  String? selectededu;

  @override
  void dispose() {
    _dateController.dispose();
    _contactController.dispose();
    _eduController.dispose();
    _emailController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _majorController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<http.StreamedResponse?> register(
      String firstName,
      String lastName,
      String dateOfbirth,
      String school,
      String education,
      String major,
      String gender,
      String contact,
      String email,
      String password) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        dateOfbirth.isEmpty ||
        school.isEmpty ||
        education.isEmpty ||
        major.isEmpty ||
        gender.isEmpty ||
        contact.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
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
      var url = Uri.parse('${UtilClass.ipAddress}RegisterSeeker.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'firstname': firstName,
        'lastname': lastName,
        'dateofbirth': dateOfbirth,
        'education': education,
        'major': major,
        'gender': gender,
        'contact': contact,
        'username': email,
        'password': password,
        'usertypeid': '1',
        'school': school
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response;
    }
  }

  Future<void> _insertData(
      String firstName,
      String lastName,
      String dateOfbirth,
      String school,
      String education,
      String major,
      String gender,
      String contact,
      String email,
      String password) async {
    try {
      // Make the POST request
      final response = await register(firstName, lastName, dateOfbirth, school,
          education, major, gender, contact, email, password);

      if (response?.statusCode == 200) {
        dynamic data = await response?.stream.bytesToString();
        final result = json.decode(data);

        if (result[0]['success']) {
          Future.delayed(const Duration(seconds: 2), () {
            Fluttertoast.showToast(
              msg: result[0]['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
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
              msg: "Something went wrong!",
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
          _isLoading = false; // Hide loading indicator
          Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[600],
            textColor: Colors.white,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
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
                            setState(() {
                              dateOfBirth = dob.toIso8601String();

                              _dateController.text = DateFormat('yyyy-MM-dd')
                                  .format(
                                      dob); // show selected date in the text field
                            });
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
                          labelText: 'Name of School',
                        ),
                        controller: _schoolController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your School name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          school = value;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Education level',
                        ),
                        value: selectededu,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectededu = newValue!;
                          });
                        },
                        items: educaions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select Education level';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          education = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Major/Degree (optional)',
                        ),
                        controller: _majorController,
                        onSaved: (value) {
                          major = value;
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
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                        ),
                        value: selectedgender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedgender = newValue!;
                          });
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
                          gender = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else {
                            password1 = value;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password1 = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password Again',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password again';
                          }

                          if (value != password1) {
                            return 'Password not the same';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password2 = value;
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
                              _insertData(
                                  firstName!,
                                  lastName!,
                                  _dateController.text,
                                  school!,
                                  education!,
                                  major!,
                                  selectedgender!,
                                  contact!,
                                  email!,
                                  password2!);
                            }
                          },
                          child: const Text('Submit'),
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
