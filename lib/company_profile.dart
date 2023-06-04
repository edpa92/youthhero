import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:http/http.dart' as http;

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePage();
}

class _CompanyProfilePage extends State<CompanyProfilePage> {
  bool _isLoading = false;
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        _image = File(pickedImage.path);
        final response = await uploadImage(_image!);

        if (response.statusCode == 200) {
          dynamic data = await response.stream.bytesToString();
          print(data);
          final result = json.decode(data);

          if (result[0]['success']) {
            String newbase64Pic =
                base64Encode(_image?.readAsBytesSync() as List<int>);
            UtilClass.prefs?.setString(UtilClass.companyLogoKey, newbase64Pic);
            setState(() async {
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

  Future<http.StreamedResponse> uploadImage(File imageFile) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${UtilClass.ipAddress}CompanyUpdateLogo.php'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['username'] =
        UtilClass.prefs!.getString(UtilClass.unameKey)!;
    request.fields['password'] = UtilClass.prefs!.getString(UtilClass.pwKey)!;
    request.fields['companyid'] =
        UtilClass.prefs!.getString(UtilClass.accountIdKey)!;

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final String? disName =
        UtilClass.prefs?.getString(UtilClass.displayNameKey);
    final String? compDisc = UtilClass.prefs?.getString(UtilClass.compDescKey);
    final String? compWebsite =
        UtilClass.prefs?.getString(UtilClass.compWebsiteKey);

    return WillPopScope(
        onWillPop: () async {
          // Custom logic for back button press
          // Return true to allow back navigation, or false to prevent it
          // You can add your own logic here

          // Example: Show an AlertDialog to confirm before leaving the page
          Navigator.pop(context, true);
          // Return false to prevent back navigation without confirmation
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Company Profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading
                    ? const Center(
                        heightFactor: 10, child: CircularProgressIndicator())
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: (UtilClass.prefs!
                                .getString(UtilClass.companyLogoKey)
                                .toString()
                                .isNotEmpty
                            ? UtilClass.getCompanyLogo()
                            : const AssetImage('assets/images/rocket.png')),
                      ),
                const SizedBox(height: 20),
                Text(
                  disName!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  compDisc!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  compWebsite!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: const Text('Change Logo'),
                ),
              ],
            ),
          ),
        ));
  }
}

void main() => runApp(
      const CompanyProfilePage(),
    );
