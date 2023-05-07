import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../data/sqldb.dart';

class HtmlViwerScreen extends StatefulWidget {
  final String title;
  final String text;
  final String id;
  const HtmlViwerScreen({
    super.key,
    required this.text,
    required this.title,
    required this.id,
  });

  @override
  State<HtmlViwerScreen> createState() => _HtmlViwerScreenState();
}

class _HtmlViwerScreenState extends State<HtmlViwerScreen> {
  SqlDb sqlDb = SqlDb();
  double fontSize = 18;
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () async {
                int response = await sqlDb.insertData('''
                                     INSERT INTO contentmodel ("id_content" , "name")
                                     VALUES ("${widget.id}", "${widget.title}")
                                      ''');
                print('persson=======================$response');
                if (response > 0) {
                  print('isFavorit===============');
                  setState(() {
                    isFavorite = true;
                  });
                }
              },
              icon: const Icon(
                Icons.favorite_rounded,
              ),
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
        floatingActionButton: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
