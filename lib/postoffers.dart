import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostOfferPage extends StatefulWidget {
  const PostOfferPage({Key? key}) : super(key: key);

  @override
  _PostOfferPageState createState() => _PostOfferPageState();
}

class _PostOfferPageState extends State<PostOfferPage> {
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
