import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class Mp3Mp4Player extends StatefulWidget {
  final String title;

  const Mp3Mp4Player({
    super.key,
    required this.title,
  });

  @override
  State<Mp3Mp4Player> createState() => _Mp3Mp4PlayerState();
}

class _Mp3Mp4PlayerState extends State<Mp3Mp4Player> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController),
          ],
        ),
      ),
    );
  }
}
