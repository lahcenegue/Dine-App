import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

import '../data/sqldb.dart';

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
  SqlDb sqlDb = SqlDb();
  bool? isFavorite;
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  Future<List<Map>> checkFavorite() async {
    List<Map> response = await sqlDb
        .readData("SELECT * FROM contentmodel WHERE id_content = ${widget.id}");

    if (response.isEmpty) {
      setState(() {
        isFavorite = false;
      });
    } else {
      setState(() {
        isFavorite = true;
      });
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
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
        body: CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController),
      ),
    );
  }
}
