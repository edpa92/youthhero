import 'package:flutter/material.dart';
import 'package:dt_webview_flutter/webview_flutter.dart';

class NewsViewPage extends StatefulWidget {
  final String url;

  NewsViewPage({Key? key, required this.url}) : super(key: key);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
