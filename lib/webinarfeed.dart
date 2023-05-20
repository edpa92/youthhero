import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebinarViewPage extends StatefulWidget {
  final String url;

  const WebinarViewPage({Key? key, required this.url}) : super(key: key);
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
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.youtube.com/results?search_query=webinar'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webinar'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
