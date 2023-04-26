import 'package:flutter/material.dart';
import 'package:videoapp/video_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
      ),
      body: const VideoPlayerView(
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      ),
    );
  }
}
