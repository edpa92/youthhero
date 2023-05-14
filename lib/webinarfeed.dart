import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youthhero/offerfeed.dart';
import 'package:youthhero/seekeraccount.dart';

import 'newsfeed.dart';

class WebinarViewPage extends StatefulWidget {
  final String url;

  WebinarViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebinarViewPageState createState() => _WebinarViewPageState();
}

class _WebinarViewPageState extends State<WebinarViewPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webinar'),
      ),
      body: WebView(
        initialUrl: widget.url,
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

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OfferFeedsPage()),
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
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountManagementPage()),
      );
    }
  }
}
