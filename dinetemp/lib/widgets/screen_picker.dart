import 'package:flutter/material.dart';
import '../players/audio_player_screen.dart';
import '../players/mp4_player.dart';
import '../players/pdf_player_screen.dart';
import '../players/youtube_player_screen.dart';
import '../view_model/content_view_model.dart';

Widget screenPiker(ContentViewModel contentViewModel) {
  //get type info
  Iterable<String> mp3 = contentViewModel.listLinks!.where(
    (element) => element.contains('mp3'),
  );
  Iterable<String> pdf = contentViewModel.listLinks!.where(
    (element) => element.contains('pdf'),
  );
  Iterable<String> youtube = contentViewModel.listLinks!.where(
    (element) => element.contains('youtube'),
  );
  Iterable<String> mp4 = contentViewModel.listLinks!.where(
    (element) => element.contains('mp4'),
  );

  //mp3 pages
  if (mp3.isNotEmpty) {
    List<String> mp3Links = [];
    for (int i = 0; i < contentViewModel.listLinks!.length; i++) {
      if (contentViewModel.listLinks![i].contains('.mp3')) {
        mp3Links.add(contentViewModel.listLinks![i]);
      }
    }

    return AudioPlayerScreen(
      listLink: mp3Links,
      id: contentViewModel.id,
      title: contentViewModel.name,
    );
  }

  //pdf pages
  else if (pdf.isNotEmpty) {
    return PdfPlayerScreen(
      link: contentViewModel.listLinks!.first,
      title: contentViewModel.name,
    );
  }

  //youtube pages
  else if (youtube.isNotEmpty) {
    return YoutubeVideoPlayerScreen(
      videoUrl: contentViewModel.listLinks!.first,
      title: contentViewModel.name,
    );
  }

  //mp4 pages
  else if (mp4.isNotEmpty) {
    return Mp4PlayerScreen(
      videoUrl: contentViewModel.listLinks!.first,
      title: contentViewModel.name,
    );
  }

  return const Scaffold(
    body: Center(
      child: Text('قريبا'),
    ),
  );
}
