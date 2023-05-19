import 'package:flutter/material.dart';
import 'package:dt_webview_flutter/webview_flutter.dart';

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
