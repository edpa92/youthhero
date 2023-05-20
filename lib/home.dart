import 'package:flutter/material.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/newsfeed.dart';
import 'package:youthhero/seeker_profile.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:youthhero/webinarfeed.dart';

void main() => runApp(const MyHomePage());

List<Widget> mydrower(BuildContext context) {
  final String? disName = UtilClass.prefs?.getString(UtilClass.displayNameKey);
  final String? disMail = UtilClass.prefs?.getString(UtilClass.unameKey);

  final List<Widget> menuItems = [
    UserAccountsDrawerHeader(
      accountName: Text(disName ?? "",
          style: const TextStyle(
              color: Color.fromARGB(255, 240, 83, 83),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              backgroundColor:
                  Color.fromRGBO(67, 67, 67, 1) // Change the text color here
              )),
      accountEmail: Text(disMail ?? "",
          style: const TextStyle(
              color: Color.fromARGB(255, 132, 233, 107),
              fontWeight: FontWeight.bold,
              fontSize: 15,
              backgroundColor: Color.fromARGB(255, 67, 67,
                  67) // Change the text color here // Change the text color here
              )),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/profile.png'),
      ),
      decoration: const BoxDecoration(
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
            fontWeight: FontWeight.bold // Change the text color here
            ),
      ),
      leading: const Icon(Icons.home),
      onTap: () {},
    ),
    ListTile(
      title: const Text('Jobs Offers',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 238, 238),
              fontWeight: FontWeight.bold,
              fontSize: 12 // Change the text color here
              )),
      leading: const Icon(Icons.work_rounded),
      onTap: () {},
    ),
    ListTile(
      title: const Text('Free Webinars ',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 238, 238),
              fontWeight: FontWeight.bold,
              fontSize: 12 // Change the text color here
              )),
      leading: const Icon(Icons.video_call),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WebinarViewPage(
              url: 'https://www.youtube.com/results?search_query=webinar',
            ),
          ),
        );
      },
    ),
    ListTile(
      title: const Text('News Feeds',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 238, 238),
              fontWeight: FontWeight.bold,
              fontSize: 12 // Change the text color here
              )),
      leading: const Icon(Icons.newspaper),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewsViewPage(
              url: 'https://mindanews.com',
            ),
          ),
        );
      },
    ),
    ListTile(
      title: const Text('Profile',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 238, 238),
              fontWeight: FontWeight.bold,
              fontSize: 12 // Change the text color here
              )),
      leading: const Icon(Icons.person),
      onTap: () {
        if ((UtilClass.prefs?.getBool(UtilClass.isSeekerKey) ?? false)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SeekerProfilePage()),
          );
        }
      },
    ),
    Expanded(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromARGB(
                          255, 0, 0, 0), // Change the line color here
                    ),
                  ),
                ),
                child: ListTile(
                  title: const Text('Logout',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 238, 238),
                          fontWeight: FontWeight.bold,
                          fontSize: 12 // Change the text color here
                          )),
                  leading: const Icon(Icons.logout),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('LOGGING OUT'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (UtilClass.prefs != null) {
                              UtilClass.prefs!.remove(UtilClass.isLogInKey);
                              UtilClass.prefs!.remove(UtilClass.unameKey);
                              UtilClass.prefs!.remove(UtilClass.pwKey);
                              UtilClass.prefs!.remove(UtilClass.displayNameKey);
                              UtilClass.prefs!.remove(UtilClass.uidKey);
                              UtilClass.prefs!.remove(UtilClass.accountIdKey);
                              UtilClass.prefs!.remove(UtilClass.isSeekerKey);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ),
                )))),
  ];

  return menuItems;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: Drawer(
            child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 67, 135, 204), // Change the color here
          ),
          child: ListView(children: mydrower(context)),
        )),
        appBar: AppBar(title: const Text('Home')),
        body: const MyScaffoldBody(),
      ),
      color: Colors.blue,
    );
  }
}

class MyScaffoldBody extends StatelessWidget {
  const MyScaffoldBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
