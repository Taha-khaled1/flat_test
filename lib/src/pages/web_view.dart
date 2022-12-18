import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WebViewExample extends StatefulWidget {
  final String data;
  final String name;

  WebViewExample(this.data, this.name);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: Text(
          widget.name,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        elevation: 0,
      ),
      body: Html(
        data: widget.data,
        shrinkWrap: true,
      ),
    );
  }
}
