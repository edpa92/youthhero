import 'package:flutter/material.dart';
import 'package:dt_webview_flutter/webview_flutter.dart';
import 'package:youthhero/home.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/seekeraccount.dart';
import 'package:youthhero/utils/uti_class.dart';

class WebinarViewPage extends StatefulWidget {
  final String url;

  WebinarViewPage({Key? key, required this.url}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _WebinarViewPageState createState() => _WebinarViewPageState();
}

class _WebinarViewPageState extends State<WebinarViewPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webinar'),
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
