import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPlayerScreen extends StatefulWidget {
  final String link;
  final String title;
  const PdfPlayerScreen({
    super.key,
    required this.link,
    required this.title,
  });

  @override
  State<PdfPlayerScreen> createState() => _PdfPlayerScreenState();
}

class _PdfPlayerScreenState extends State<PdfPlayerScreen> {
  PdfViewerController pdfViewerController = PdfViewerController();
  TextEditingController textEditingController = TextEditingController();
  double zoom = 1.0;

  searchWord(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ادخل كلمة البحث'),
          content: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.text,
            onSubmitted: (val) {
              textEditingController.text = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                pdfViewerController.searchText(textEditingController.text);
                Navigator.pop(context);
              },
              child: const Text('بحث'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('رجوع'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                searchWord(context);
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: SfPdfViewer.network(
          widget.link,
          controller: pdfViewerController,
        ),
        floatingActionButton: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
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
                  zoom = zoom + 0.5;
                  pdfViewerController.zoomLevel = zoom;
                },
                icon: const Icon(Icons.zoom_in),
              ),
              IconButton(
                onPressed: () {
                  if (zoom > 3) {
                    zoom = 3;
                  }
                  zoom = zoom - 0.5;
                  pdfViewerController.zoomLevel = zoom;
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