import 'package:dinetemp/widgets/check_permission.dart';

import '../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/navigation_screen.dart';

bool isPermission = false;

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await checkPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: kMainColor,
      ),
      home: const NavigationScreen(),
    );
  }
}
