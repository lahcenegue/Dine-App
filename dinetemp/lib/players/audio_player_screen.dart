import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../constants/constants.dart';
import '../data/sqldb.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<String> listLink;
  final String id;
  final String title;
  const AudioPlayerScreen({
    super.key,
    required this.listLink,
    required this.id,
    required this.title,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  SqlDb sqlDb = SqlDb();

  late AudioPlayer _audioPlayer;
  List<AudioSource> playListChildren = [];
  bool? isFavorite;

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

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    checkFavorite();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    String urlSound;
    for (int i = 0; i < widget.listLink.length; i++) {
      urlSound = widget.listLink[i];

      playListChildren.add(
        AudioSource.uri(
          Uri.parse(urlSound),
          tag: MediaItem(
            id: '${widget.id}$i',
            title: widget.title,
            artUri: Uri.parse(kSoundInage),
          ),
        ),
      );
    }

    final playList = ConcatenatingAudioSource(
      children: playListChildren,
    );
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playList);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
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
          backgroundColor: kGradianColor1,
          elevation: 0,
        ),
        extendBody: true,
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kGradianColor1,
                kGradianColor2,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return MediaMetaData(
                    imageUrl: metadata.artUri.toString(),
                    artist: metadata.artist ?? '',
                    title: metadata.title,
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    baseBarColor: Colors.grey[600],
                    bufferedBarColor: Colors.grey,
                    progressBarColor: Colors.red,
                    thumbColor: Colors.red,
                    timeLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  );
                },
              ),
              const SizedBox(height: 20),
              Controls(
                audioPlayer: _audioPlayer,
                audioLength: playListChildren.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final int audioLength;
  const Controls({
    super.key,
    required this.audioPlayer,
    required this.audioLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToNext,
          iconSize: 60,
          color: audioLength <= 1 ? Colors.grey[700] : Colors.white,
          icon: const Icon(Icons.skip_next_rounded),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          iconSize: 60,
          color: audioLength <= 1 ? Colors.grey[700] : Colors.white,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class MediaMetaData extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;
  const MediaMetaData({
    super.key,
    required this.artist,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          artist,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
