import 'package:dinetemp/view_model/home_view_model.dart';
import 'package:dinetemp/view_model/subcategories_view_model.dart';
import 'package:flutter/material.dart';

import '../players/audio_player_screen.dart';
import '../players/html_viewer_screen.dart';

class ContentScreen extends StatefulWidget {
  final SubMatterViewModel subMatterViewModel;
  const ContentScreen({
    super.key,
    required this.subMatterViewModel,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  HomeViewModel hvm = HomeViewModel();
  @override
  void initState() {
    super.initState();
    hvm.fetchContentData(widget.subMatterViewModel.id);
  }

  @override
  Widget build(BuildContext context) {
    hvm.addListener(() {
      setState(() {});
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subMatterViewModel.name,
          ),
        ),
        body: hvm.contentData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : hvm.contentData!.listLinks!.isEmpty
                ? HtmlViwerScreen(
                    text: hvm.contentData!.comment,
                  )
                : Center(
                    child: Column(
                      children: [
                        Text(hvm.contentData!.listLinks![0]),
                      ],
                    ),
                  ),
      ),
    );
  }
}
