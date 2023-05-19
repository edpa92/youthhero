import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youthhero/home.dart';
import 'package:youthhero/recruitersignup.dart';
import 'package:youthhero/signup.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthhero/utils/uti_class.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String logEmail = '';
  String logPassword = '';
  bool authenticated = false;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  void _login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email/Password must be not empty",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
    }
    final prefs = await SharedPreferences.getInstance();

    print("Loging in");

    if (_formKey.currentState!.validate()) {
      try {
        // Make the POST request
        final response = await login(email, password);

        // Check the response status code
        if (response.statusCode == 200) {
          dynamic data = await response.stream.bytesToString();
          print("$data $email $password");
          final result = json.decode(data);
          print(result[0]);
          if (result[0]['success']) {
            print("success");
            prefs.setBool(UtilClass.isLogInKey, true);
            prefs.setString(UtilClass.unameKey, email);
            prefs.setString(UtilClass.pwKey, password);
            prefs.setString(UtilClass.displayNameKey, result[0]['displayname']);
            prefs.setString(UtilClass.uidKey, result[0]['uid']);
            prefs.setString(UtilClass.accountIdKey, result[0]['accountid']);
            prefs.setBool(UtilClass.isSeekerKey, result[0]['isseeker']);
            print("all preff saves");

            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _isLoading = false; // Hide loading indicator
                Fluttertoast.showToast(
                  msg: "Login Successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                );
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                (route) => false,
              );
            });
          } else {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _isLoading = false; // Hide loading indicator
                Fluttertoast.showToast(
                  msg: "Invalid Username/Password",
                  toastLength: Toast.LENGTH_SHORT,
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
                msg: "Request failed",
                toastLength: Toast.LENGTH_SHORT,
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
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
            );
          });
        });
      }
    }
  }

  Future<http.StreamedResponse> login(String email, String password) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var url = Uri.parse('${UtilClass.ipAddress}Login.php');
    var request = http.Request('POST', url);
    request.bodyFields = {'username': email, 'password': password};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(
                  heightFactor: 10, child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                        logEmail = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      controller: _pwController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        logPassword = value!;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true; // Show loading indicator
                              });

                              print("login button click");
                              _login(_emailController.text, _pwController.text);
                            }
                          },
                          child: const Text('Login'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons
                                            .build_circle), // Add the desired icon here
                                        label: const Text('As Job Seeker'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegistrationForm()),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons
                                            .house), // Add the desired icon here
                                        label: const Text('As Employeer'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RecruiterRegForm()),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
