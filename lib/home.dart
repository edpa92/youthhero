import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:youthhero/login.dart';
import 'package:youthhero/seekeraccount.dart';
import 'package:youthhero/utils/uti_class.dart';
import 'package:youthhero/webinarfeed.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      color: Colors.blue,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  List<Offer> _offers = []; // List to store the retrieved offers
  List<Offer> _filteredOffers = []; // List to store the filtered offers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call a function to retrieve offers from the server
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    // Implement the logic to fetch offers from the XAMPP server as JSON
    // Parse the JSON response and populate the _offers list

    setState(() {
      _filteredOffers = _offers; // Set filtered offers initially to all offers
    });
  }

  Future<void> _postOffer() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    // Create a JSON object from the entered data
    final Map<String, dynamic> offerData = {
      'title': title,
      'description': description,
    };

    // Convert the JSON object to a string
    final String jsonData = jsonEncode(offerData);

    // Send a POST request to your XAMPP server to store the offer in the database
    final String url = 'http://your-xampp-server-url/offers';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      // Offer posted successfully
      // Refresh the offers list or display a success message
      _fetchOffers();
    } else {
      // Failed to post the offer
      // Display an error message or handle the failure scenario
    }

    // Clear the text fields
    _titleController.clear();
    _descriptionController.clear();
  }

  void _filterOffers(String keyword) {
    setState(() {
      _filteredOffers = _offers
          .where((offer) =>
              offer.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 67, 135, 204),
          ),
          child: ListView(children: myDrawer(context)),
        ),
      ),
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterOffers,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOffers.length,
              itemBuilder: (context, index) {
                final offer = _filteredOffers[index];
                return _buildOfferCard(offer);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                ElevatedButton(
                  onPressed: _postOffer,
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    // Implement the UI for displaying an individual offer card
    // You can use a Card widget or any other widget to display the offer details
    // Customize it according to your design requirements

    return Card(
      child: ListTile(
        title: Text(offer.title),
        subtitle: Text(offer.description),
        // Add more details or customize the card as needed
      ),
    );
  }
}

class Offer {
  final String title;
  final String description;
  // Add more properties if needed

  Offer({
    required this.title,
    required this.description,
    // Initialize additional properties if needed
  });
}
