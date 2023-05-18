import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youthhero/home.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/newsfeed.dart';
import 'package:youthhero/offerfeed.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:youthhero/webinarfeed.dart';

class Seeker {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String dateOfBirth;
  final String education;
  final String major;
  final String skills;

  Seeker({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.education,
    required this.major,
    required this.skills,
  });
}

class AccountManagementPage extends StatefulWidget {
  @override
  _AccountManagementPageState createState() => _AccountManagementPageState();
}

Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  );
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  List<Widget> myDrawer(BuildContext context) {
    final List<Widget> menuItems = [
      const UserAccountsDrawerHeader(
        accountName: Text(
          'Users name',
          style: TextStyle(
            color: Color.fromARGB(255, 240, 83, 83),
            fontWeight: FontWeight.bold,
            fontSize: 25,
            backgroundColor: Color.fromARGB(255, 67, 67, 67),
          ),
        ),
        accountEmail: Text(
          'emailhere@example.com',
          style: TextStyle(
            color: Color.fromARGB(255, 132, 233, 107),
            fontWeight: FontWeight.bold,
            fontSize: 15,
            backgroundColor: Color.fromARGB(255, 67, 67, 67),
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cover.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      ListTile(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Color.fromARGB(255, 251, 243, 242),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.home),
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false,
          );
        },
      ),
      ListTile(
        title: const Text(
          'Webinars',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 238, 238),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        leading: const Icon(Icons.video_collection_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebinarViewPage(
                url: 'https://www.youtube.com/results?search_query=webinar',
              ),
            ),
          );
        },
      ),
      ListTile(
        title: const Text(
          'News',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 238, 238),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        leading: const Icon(Icons.newspaper_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebinarViewPage(
                url: 'https://www.mindanews.com',
              ),
            ),
          );
        },
      ),
      ListTile(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 238, 238),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        leading: const Icon(Icons.person),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountManagementPage()),
          );
        },
      ),
      Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            child: ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 238, 238),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              leading: const Icon(Icons.logout),
              onTap: () {
                if (UtilClass.prefs != null) {
                  UtilClass.prefs!.remove(UtilClass.isLogInKey);
                  UtilClass.prefs!.remove(UtilClass.unameKey);
                  UtilClass.prefs!.remove(UtilClass.pwKey);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ),
      ),
    ];

    return menuItems;
  }

  List<Seeker> seekers = [];
  int _selectedIndex = 3;
  @override
  void initState() {
    super.initState();
    fetchSeekerData();
  }

  Future<void> fetchSeekerData() async {
    final response = await http
        .get(Uri.parse('http://192.168.43.219/youthheroapi/Login.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Seeker> loadedSeekers = [];
      data.forEach((key, value) {
        loadedSeekers.add(Seeker(
          id: key,
          firstName: value['firstName'],
          lastName: value['lastName'],
          email: value['email'],
          password: value['password'],
          dateOfBirth: value['dateOfBirth'],
          education: value['education'],
          major: value['major'],
          skills: value['skills'],
        ));
      });
      setState(() {
        seekers = loadedSeekers;
      });
    } else {
      throw Exception('Failed to fetch data from the server');
    }
  }

  Future<void> updateSeekerData(String id, Seeker updatedSeeker) async {
    final response = await http.put(
      Uri.parse('http://your-xampp-server-url/seekers/$id.json'),
      body: json.encode({
        'firstName': updatedSeeker.firstName,
        'lastName': updatedSeeker.lastName,
        'email': updatedSeeker.email,
        'password': updatedSeeker.password,
        'dateOfBirth': updatedSeeker.dateOfBirth,
        'education': updatedSeeker.education,
        'major': updatedSeeker.major,
        'skills': updatedSeeker.skills,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update data on the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
      ),
      body: ListView.builder(
        itemCount: seekers.length,
        itemBuilder: (context, index) {
          final seeker = seekers[index];
          return ListTile(
            title: Text('${seeker.firstName} ${seeker.lastName}'),
            subtitle: Text(seeker.email),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String updatedFirstName = seeker.firstName;
                    String updatedLastName = seeker.lastName;
                    String updatedEmail = seeker.email;
                    String updatedPassword = seeker.password;
                    String updatedDateOfBirth = seeker.dateOfBirth;
                    String updatedEducation = seeker.education;
                    String updatedMajor = seeker.major;
                    String updatedSkills = seeker.skills;

                    return AlertDialog(
                      title: const Text('Edit Seeker'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: seeker.firstName,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                              ),
                              onChanged: (value) {
                                updatedFirstName = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.lastName,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                              ),
                              onChanged: (value) {
                                updatedLastName = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.email,
                              onChanged: (value) {
                                updatedEmail = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.password,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              onChanged: (value) {
                                updatedPassword = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.dateOfBirth,
                              decoration: const InputDecoration(
                                labelText: 'Date of Birth',
                              ),
                              onChanged: (value) {
                                updatedDateOfBirth = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.education,
                              decoration: const InputDecoration(
                                labelText: 'Education',
                              ),
                              onChanged: (value) {
                                updatedEducation = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.major,
                              decoration: const InputDecoration(
                                labelText: 'Major',
                              ),
                              onChanged: (value) {
                                updatedMajor = value;
                              },
                            ),
                            TextFormField(
                              initialValue: seeker.skills,
                              decoration: const InputDecoration(
                                labelText: 'Skills',
                              ),
                              onChanged: (value) {
                                updatedSkills = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final updatedSeeker = Seeker(
                              id: seeker.id,
                              firstName: updatedFirstName,
                              lastName: updatedLastName,
                              email: updatedEmail,
                              password: updatedPassword,
                              dateOfBirth: updatedDateOfBirth,
                              education: updatedEducation,
                              major: updatedMajor,
                              skills: updatedSkills,
                            );

                            await updateSeekerData(seeker.id, updatedSeeker);

                            setState(() {
                              seekers[index] = updatedSeeker;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_rounded),
            label: 'Webinar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3),
            label: 'Profile/Account',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebinarViewPage(
            url:
                'https://www.youtube.com/results?search_query=webinar', // Replace with your desired URL
          ),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsViewPage(
            url: 'https://www.mindanews.com', // Replace with your desired URL
          ),
        ),
      );
    }
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OfferFeedsPage()),
      );
    }
  }
}
