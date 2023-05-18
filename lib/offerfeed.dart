import 'package:flutter/material.dart';
import 'package:youthhero/newsfeed.dart';
import 'package:youthhero/seekeraccount.dart';
import 'package:youthhero/webinarfeed.dart';

class OfferFeedsPage extends StatefulWidget {
  const OfferFeedsPage({Key? key}) : super(key: key);

  @override
  _OfferFeedsPageState createState() => _OfferFeedsPageState();
}

class _OfferFeedsPageState extends State<OfferFeedsPage> {
  List<Offer> _offers = []; // List to store the retrieved offers
  List<Offer> _filteredOffers = []; // List to store the filtered offers
  int _selectedIndex = 0;

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
      appBar: AppBar(
        title: const Text('Offer Feeds'),
      ),
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
        ],
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
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountManagementPage()),
      );
    }
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
