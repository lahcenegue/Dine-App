import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlViwerScreen extends StatefulWidget {
  final String title;
  final String text;
  const HtmlViwerScreen({
    super.key,
    required this.text,
    required this.title,
  });

  @override
  State<HtmlViwerScreen> createState() => _HtmlViwerScreenState();
}

class _HtmlViwerScreenState extends State<HtmlViwerScreen> {
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  fontSize = fontSize + 2;
                },
              );
            },
            icon: const Icon(Icons.zoom_in),
          ),
          IconButton(
            onPressed: () {
              setState(
                () {
                  if (fontSize <= 18) {
                    fontSize = 18;
                  } else {
                    fontSize = fontSize - 2;
                  }
                },
              );
            },
            icon: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Html(
          data: widget.text,
          style: {
            "p": Style(
              padding: const EdgeInsets.all(12),
              fontSize: FontSize(fontSize),
              textAlign: TextAlign.justify,
            ),
          },
        ),
      ),
    );
  }
}
