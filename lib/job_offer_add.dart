import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:http/http.dart' as http;

class JobOfferAddPage extends StatefulWidget {
  const JobOfferAddPage({Key? key}) : super(key: key);

  @override
  _JobOfferAddPage createState() => _JobOfferAddPage();
}

var _formKey = GlobalKey<FormState>();
var _formKeyDialogCat = GlobalKey<FormState>();
var _formKeyDialogAdd = GlobalKey<FormState>();
var _isLoading = false;
var _isLoadingDialogOfferType = false;

List<Widget> chipWidgets = [];

List<Item> skillList = [];
List<String> skillIdList = [];

List<String> offertypesList = [];
List<String> offertypesIdList = [];

List<String> offerLocationsList = [];
List<String> offerLocationsIdList = [];

List<String> municipalities = [
  "Alamada",
  "Aleosan",
  "Antipas",
  "Arakan",
  "Banisilan",
  "Carmen",
  "Kabacan",
  "Kidapawan City",
  "Libungan",
  "Midsayap",
  "M'lang ",
  "Magpet",
  "Makilala",
  "Matalam",
  "M'lang",
  "Pigcawayan",
  "Pikit",
  "President Roxas",
  "Tulunan"
];

List<String> municipalitiesPostals = [
  "Alamada 9413",
  "Aleosan 9411",
  "Antipas 9414",
  "Arakan 9417",
  "Banisilan 9410",
  "Carmen 9408",
  "Kabacan 9407",
  "Kidapawan City 9400",
  "Libungan 9411",
  "Midsayap 9410",
  "M'lang 9402",
  "Magpet 9404",
  "Makilala 9401",
  "Matalam 9413",
  "M'lang 9402",
  "Pigcawayan 9417",
  "Pikit 9409",
  "President Roxas 9407",
  "Tulunan 9416",
];

List<String> postals = [
  "9413",
  "9411",
  "9414",
  "9417",
  "9410",
  "9408",
  "9407",
  "9400",
  "9411",
  "9410",
  "9402",
  "9404",
  "9401",
  "9413",
  "9402",
  "9417",
  "9409",
  "9407",
  "9416",
];

final _perhourRateController = TextEditingController();
final _offerController = TextEditingController();
final _locationController = TextEditingController();

String? perhourRate;
String? seletedOffertype;
String? seletedOffertypeId;
String? seletedOfferLocation;
String? jobofferdescription;
String selectedLocationId = "";

String? _streetname;
String? selectedMuniPos;
bool _isLoadingDialogSkill = false;

class Item {
  final String name;
  bool isChecked;

  Item({required this.name, this.isChecked = false});
}

class CheckedListDialog extends StatefulWidget {
  @override
  _CheckedListDialogState createState() => _CheckedListDialogState();
}

class _CheckedListDialogState extends State<CheckedListDialog> {
  List<int> checkedPositions = [];

  final _descController = TextEditingController();
  String? major;

  Future<void> addSkill(String description) async {
    setState(() {
      _isLoadingDialogSkill = true;
    });
    //try {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var url = Uri.parse('${UtilClass.ipAddress}SkillAdd.php');
    var request = http.Request('POST', url);
    request.bodyFields = {
      'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
      'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
      'desc': description,
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      print(data);
      final result = json.decode(data);

      if (result[0]["success"]) {
        setState(() {
          skillList.add(Item(name: description));
          skillIdList.add(result[0]["skillid"].toString());
        });
      }

      Fluttertoast.showToast(
        msg: result[0]['msg'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );

      setState(() {
        _isLoadingDialogSkill = false;
      });
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
        _isLoadingDialogSkill = false;
      });
    }
    /* } catch (e) {
      setState(() {
        _isLoadingDialogSkill = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
      );
    } */
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Checked Skill required for this job offer'),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _isLoadingDialogSkill
                ? const Center(
                    heightFactor: 10, child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter Skill Description to Add',
                            ),
                            controller: _descController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Skill';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              major = value;
                            },
                          ),
                        )),
                        ElevatedButton(
                          onPressed: () {
                            if (skillList
                                .where((element) =>
                                    element.name.toLowerCase() ==
                                    _descController.text.toLowerCase())
                                .isNotEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "Skill already exist, choose from the list below!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[600],
                                textColor: Colors.white,
                              );

                              return;
                            }
                            if (_descController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Enter Skill",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[600],
                                textColor: Colors.white,
                              );

                              return;
                            }

                            addSkill(_descController.text)
                                .then((value) => null);
                          },
                          child: const Text('Save'),
                        ),
                      ]),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: skillList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(skillList[index].name),
                    value: skillList[index].isChecked,
                    onChanged: (value) {
                      setState(() {
                        skillList[index].isChecked = value!;
                        if (value) {
                          checkedPositions.add(index);
                        } else {
                          checkedPositions.remove(index);
                        }
                      });
                    },
                  );
                },
              ),
            )
          ]),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(checkedPositions);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _JobOfferAddPage extends State<JobOfferAddPage> {
  String? _jobOfferTypeDes;

  void generateChips() {
    chipWidgets = skillList.where((value) => value.isChecked).map((data) {
      return Chip(
        label: Text(data.name),
        onDeleted: () {
          int index = skillList.indexOf(data);
          setState(() {
            skillList[index].isChecked = false;
            generateChips();
          });
        },
      );
    }).toList();
  }

  Future<void> addJobOfferType(String description) async {
    setState(() {
      _isLoadingDialogOfferType = true;
    });
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}JobOfferTypeAdd.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
        'desc': description,
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);

        Fluttertoast.showToast(
          msg: result[0]['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
        setState(() {
          _isLoadingDialogOfferType = false;
        });
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
          _isLoadingDialogOfferType = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingDialogOfferType = false;
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

  Future<void> addAddress(String street, String muni, String zip) async {
    setState(() {
      _isLoadingDialogOfferType = true;
    });
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}AddressLocationAdd.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
        'zip': zip,
        'citymunicipality': muni,
        'street': street,
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);

        Fluttertoast.showToast(
          msg: result[0]['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
        setState(() {
          _isLoadingDialogOfferType = false;
        });
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
          _isLoadingDialogOfferType = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingDialogOfferType = false;
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

  Future<void> getAllOffertypeAndLocations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url =
          Uri.parse('${UtilClass.ipAddress}GetAllOfferTypeAndAddress.php');
      var request = http.Request('POST', url);
      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);
        if (result[0]['success']) {
          offertypesIdList.clear();
          offertypesList.clear();
          offerLocationsList.clear();
          offerLocationsIdList.clear();
          skillList.clear();
          skillIdList.clear();

          var typeList = result[0]['types'];

          if (typeList != null) {
            for (var i = 0; i < typeList.length; i++) {
              offertypesList.add(typeList[i]['Description']);
              offertypesIdList.add(typeList[i]['OfferTypeId']);
            }
          }

          var addressList = result[0]['addresses'];

          for (var i = 0; i < addressList.length; i++) {
            offerLocationsList.add(addressList[i]['address']);
            offerLocationsIdList.add(addressList[i]['addressid']);
          }

          var askillList = result[0]['skills'];

          for (var i = 0; i < askillList.length; i++) {
            skillList.add(Item(name: askillList[i]['skill']));
            skillIdList.add(askillList[i]['skillid']);
          }

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
      print(e.toString());
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

  Future<void> addJobOffer(String companyId, String typeid, String locationid,
      String desc, int isActive, String hourRate, List<String> skillids) async {
    setState(() {
      _isLoadingDialogOfferType = true;
    });
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var url = Uri.parse('${UtilClass.ipAddress}JobOfferAdd.php');
      var request = http.Request('POST', url);
      final jsonStringSkillIds = json.encode(skillids);
      request.bodyFields = {
        'username': UtilClass.prefs?.getString(UtilClass.unameKey) ?? "",
        'password': UtilClass.prefs?.getString(UtilClass.pwKey) ?? "",
        'companyid': companyId,
        'typeid': typeid,
        'locationid': locationid,
        'desc': desc,
        'isactive': isActive.toString(),
        'hourrate': hourRate,
        'skillids': jsonStringSkillIds
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        print(data);
        final result = json.decode(data);

        Fluttertoast.showToast(
          msg: result[0]['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
        );
        setState(() {
          _isLoadingDialogOfferType = false;
        });
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
          _isLoadingDialogOfferType = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingDialogOfferType = false;
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
    getAllOffertypeAndLocations();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _perhourRateController.clear();
    _offerController.clear();
    _locationController.clear();
    chipWidgets.clear();
  }

  @override
  Widget build(BuildContext context) {
    void closeDialogOnsave() {
      Navigator.of(context).pop();
      getAllOffertypeAndLocations();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Job Offer'),
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
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'Job Offer Discription',
                          ),
                          maxLines: null,
                          controller: _offerController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter job offer description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            jobofferdescription = value;
                          },
                        ),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Per Hour Rate',
                          ),
                          controller: _perhourRateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Per Hour Rate';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            perhourRate = value;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Choose type of Job Offer',
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              seletedOffertype = newValue!;
                            });
                          },
                          items: offertypesList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Choose type of Job Offer';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            seletedOffertype = value;
                            seletedOffertypeId = offertypesIdList.elementAt(
                                offertypesList.indexOf(seletedOffertype!));
                          },
                        ),
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              decoration: const InputDecoration(
                                labelText: 'Search Location',
                                border: OutlineInputBorder(),
                              ),
                              controller: _locationController),
                          suggestionsCallback: (pattern) async {
                            return offerLocationsList.where((item) => item
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            _locationController.text = suggestion;
                            int index = offerLocationsList.indexOf(suggestion);
                            selectedLocationId =
                                offerLocationsIdList.elementAt(index);
                          },
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Required Skills',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final List<int>? aselectedPositions =
                                      await showDialog<List<int>>(
                                    context: context,
                                    builder: (context) => CheckedListDialog(),
                                  );
                                  setState(() {
                                    generateChips();
                                  });
                                },
                                child: const Text('+ Skill'),
                              ),
                            ]),
                        const SizedBox(height: 8.0),
                        Wrap(
                          spacing: 5.0,
                          children: chipWidgets,
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

                                if (selectedLocationId.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Search Location!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[600],
                                    textColor: Colors.white,
                                  );
                                  setState(() {
                                    _isLoading =
                                        false; // Show loading indicator
                                  });

                                  return;
                                }

                                if (skillList
                                    .where((element) => element.isChecked)
                                    .isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "No selected Required Skill(s)!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[600],
                                    textColor: Colors.white,
                                  );
                                  setState(() {
                                    _isLoading =
                                        false; // Show loading indicator
                                  });
                                  print(skillList
                                      .where((element) => element.isChecked)
                                      .toString());

                                  return;
                                }

                                List<String> selectedSkillIds = [];
                                for (var i = 0; i < skillList.length; i++) {
                                  if (skillList[i].isChecked) {
                                    selectedSkillIds.add(skillIdList[i]);
                                  }
                                }

                                addJobOffer(
                                        UtilClass.prefs!
                                            .getString(UtilClass.accountIdKey)!,
                                        seletedOffertypeId!,
                                        selectedLocationId,
                                        jobofferdescription!,
                                        1,
                                        perhourRate!,
                                        selectedSkillIds)
                                    .then(
                                        (value) => Navigator.of(context).pop());
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
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          overlayColor: Colors.black.withOpacity(0.5),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.map),
              label: 'Add Addresss Location',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Addresss Location'),
                      content: Form(
                        key: _formKeyDialogAdd,
                        child: _isLoadingDialogOfferType
                            ? const Center(
                                heightFactor: 10,
                                child: CircularProgressIndicator())
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Street name',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter Street name';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _streetname = value;
                                    },
                                  ),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Municipality/Zip',
                                    ),
                                    value: selectedMuniPos,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedMuniPos = newValue!;
                                      });
                                    },
                                    items: municipalitiesPostals
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select Munisipality';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      selectedMuniPos = value;
                                    },
                                  ),
                                ],
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKeyDialogAdd.currentState!.validate()) {
                              _formKeyDialogAdd.currentState!.save();

                              setState(() {
                                _isLoadingDialogOfferType = true;
                              });
                              addAddress(
                                      _streetname!,
                                      municipalities.elementAt(
                                          municipalitiesPostals
                                              .indexOf(selectedMuniPos!)),
                                      postals.elementAt(municipalitiesPostals
                                          .indexOf(selectedMuniPos!)))
                                  .then((value) => closeDialogOnsave());
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.handyman),
              label: 'Add Job Offer Type',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add JobOffer Type'),
                      content: Form(
                        key: _formKeyDialogCat,
                        child: _isLoadingDialogOfferType
                            ? const Center(
                                heightFactor: 10,
                                child: CircularProgressIndicator())
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText:
                                          'JobOffer Type Description (e.g. Carpentry, Computer Repair etc)',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter JobOffer Type description';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _jobOfferTypeDes = value;
                                    },
                                  ),
                                ],
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKeyDialogCat.currentState!.validate()) {
                              _formKeyDialogCat.currentState!.save();

                              setState(() {
                                _isLoading = true;
                              });
                              addJobOfferType(_jobOfferTypeDes!)
                                  .then((value) => closeDialogOnsave());
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ));
  }
}
