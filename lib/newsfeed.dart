import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsViewPage extends StatefulWidget {
  final String url;

  const NewsViewPage({Key? key, required this.url}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _NewsViewPageState createState() => _NewsViewPageState();
}

class _NewsViewPageState extends State<NewsViewPage> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://mindanews.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
