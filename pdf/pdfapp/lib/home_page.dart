import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('pdf'),
        actions: [
          IconButton(
            onPressed: () {
              pdfViewerController.previousPage();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () {
              pdfViewerController.nextPage();
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
          IconButton(
            onPressed: () {
              searchWord(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
        controller: pdfViewerController,
      ),
      floatingActionButton: Container(
        width: 120,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
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
    );
  }
}
