import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youthhero/login.dart';
// ignore: unused_import
import 'package:youthhero/recruitersignup.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:http/http.dart' as http;

class RecruiterRegForm extends StatefulWidget {
  const RecruiterRegForm({super.key});

  @override
  RecruiterRegFormState createState() => RecruiterRegFormState();
}

class RecruiterRegFormState extends State<RecruiterRegForm> {
  final _formKey = GlobalKey<FormState>();

  String? company;
  String? rEmail;
  String? rDesc;
  String? rWebsite;
  String? rPassword2;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descController = TextEditingController();

  String? rPassword;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _companyNameController.dispose();
    _websiteController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _insertData(String company, String rEmail, String? rDesc,
      String? rWebsite, String rPassword2) async {
    print("$company $rDesc $rEmail $rWebsite $rPassword2");
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}RegisterCompany.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'companyname': company,
        'description': rDesc ?? "",
        'website': rWebsite ?? "",
        'email': rEmail,
        'password': rPassword2
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        final result = json.decode(data);

        if (result[0]['success']) {
          setState(() {
            _isLoading = false;
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
              msg: "Status connection Error",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          });
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false; // Hide loading indicator
          Fluttertoast.showToast(
            msg: e.toString(),
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
        title: const Text('Company Registration'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(
                  heightFactor: 10, child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Company/Organization name *',
                        ),
                        controller: _companyNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your company name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          company = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Company Description',
                        ),
                        controller: _descController,
                        onSaved: (value) {
                          rDesc = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Company Website ',
                        ),
                        controller: _websiteController,
                        onSaved: (value) {
                          rWebsite = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email/Username *',
                        ),
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          rEmail = value;
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
                            rPassword = value;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          rPassword = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password Again',
                        ),
                        obscureText: true,
                        controller: _pwController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password again';
                          }

                          if (value != rPassword) {
                            return 'Password not the same';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          rPassword2 = value;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("pressed");
                              _formKey.currentState!.save();
                              setState(() {
                                _isLoading = true; // Show loading indicator
                              });
                              _insertData(
                                  _companyNameController.text,
                                  _emailController.text,
                                  _descController.text,
                                  _websiteController.text,
                                  _pwController.text);
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
