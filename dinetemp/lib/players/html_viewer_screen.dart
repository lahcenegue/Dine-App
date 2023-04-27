import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlViwerScreen extends StatelessWidget {
  final String text;
  const HtmlViwerScreen({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Html(
          data: text,
        ),
      ],
    );
  }
}
