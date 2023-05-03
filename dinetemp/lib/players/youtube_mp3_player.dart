import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as bar;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/constants.dart';
import 'audio_player_screen.dart';

class YoutubeMp3Player extends StatefulWidget {
  final String title;
  final String id;
  final List<String> videoUrls;

  const YoutubeMp3Player({
    super.key,
    required this.title,
    required this.id,
    required this.videoUrls,
  });

  @override
  State<YoutubeMp3Player> createState() => _YoutubeMp3PlayerState();
}

class _YoutubeMp3PlayerState extends State<YoutubeMp3Player> {
  //Audio part
  late AudioPlayer _audioPlayer;
  List<AudioSource> playListChildren = [];
  late String mp3Link;

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
  Future<void> _init() async {
    final playList = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          Uri.parse(mp3Link),
          tag: MediaItem(
            id: widget.id,
            title: widget.title,
            artUri: Uri.parse(kSoundInage),
          ),
        ),
      ],
    );
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playList);
  }

  //Youtube Part
  late YoutubePlayerController _youtubePlayerController;
  late String youtubeLink;

  @override
  void initState() {
    super.initState();
    // youtubeLink =
    //     widget.videoUrls.where((element) => element == 'youtube').toString();
    for (int i = 0; i < widget.videoUrls.length; i++) {
      if (widget.videoUrls[i].contains('.mp3')) {
        mp3Link = widget.videoUrls[i];
      } else {
        youtubeLink = widget.videoUrls[i];
      }
    }
    _audioPlayer = AudioPlayer();
    _init();
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(youtubeLink)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _youtubePlayerController.pause();
    super.deactivate();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //////////// youtube
            Expanded(
              child: YoutubePlayerBuilder(
                onExitFullScreen: () {
                  SystemChrome.setPreferredOrientations(
                      DeviceOrientation.values);
                },
                player: YoutubePlayer(
                  aspectRatio: 16 / 9,
                  controller: _youtubePlayerController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: kMainColor,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.red,
                        backgroundColor: Colors.grey,
                        bufferedColor: Colors.white,
                      ),
                    ),
                    RemainingDuration(),
                    FullScreenButton(),
                  ],
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(12),
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
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return bar.ProgressBar(
                        barHeight: 5,
                        baseBarColor: Colors.grey[600],
                        bufferedBarColor: Colors.grey,
                        progressBarColor: Colors.red,
                        thumbColor: Colors.red,
                        timeLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: _audioPlayer.seek,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Controls(
                    audioPlayer: _audioPlayer,
                    audioLength: playListChildren.length,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
