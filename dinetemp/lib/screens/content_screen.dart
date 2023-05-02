import 'package:dinetemp/view_model/home_view_model.dart';
import 'package:dinetemp/view_model/subcategories_view_model.dart';
import 'package:flutter/material.dart';

import '../players/audio_player_screen.dart';
import '../players/html_viewer_screen.dart';
import '../widgets/screen_picker.dart';

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

    if (hvm.contentData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (hvm.contentData!.listLinks!.isEmpty) {
      return Scaffold(
        body: HtmlViwerScreen(
          title: hvm.contentData!.name,
          text: hvm.contentData!.comment,
        ),
      );
    } else {
      return Scaffold(
        body: screenPiker(hvm.contentData!),
      );
    }
  }
}
