import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import '../widgets/button_favorite.dart';
import '../widgets/download_item.dart';

class Mp4PlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String id;
  final String title;
  const Mp4PlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.id,
  });

  @override
  State<Mp4PlayerScreen> createState() => _Mp4PlayerScreenState();
}

class _Mp4PlayerScreenState extends State<Mp4PlayerScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
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
          actions: [
            ButtonFavorite(id: widget.id, title: widget.title),
          ],
        ),
        body: Column(
          children: [
            CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController),
            const Spacer(),
            SizedBox(
                child: DownloadItem(
              title: '1- ${widget.title}',
              url: widget.videoUrl,
            )),
          ],
        ),
      ),
    );
  }
}
