import 'package:academy_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class PlayVideoFromAsset extends StatefulWidget {
  const PlayVideoFromAsset({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromAsset> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<PlayVideoFromAsset> {
  late final PodPlayerController controller;
  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.asset('assets/SampleVideo_720x480_20mb.mp4'),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Stack(
          children: [
            PodVideoPlayer(
              controller: controller,
              podPlayerLabels: const PodPlayerLabels(
                play: "PLAY",
                pause: "PAUSE",
                error: "ERROR WHILE TRYING TO PLAY VIDEO",
                exitFullScreen: "EXIT FULL SCREEN",
                fullscreen: "FULL SCREEN",
                loopVideo: "LOOP VIDEO",
                mute: "MUTE",
                playbackSpeed: "PLAYBACK SPEED",
                settings: "SETTINGS",
                unmute: "UNMUTE",
                optionEnabled: "YES",
                optionDisabled: "NO",
                quality: "QUALITY",
              ),
            ),
            Center(
                child: Transform.rotate(
                    angle: -0.45,
                    child: IgnorePointer(
                        child: Opacity(
                            opacity: 0.2,
                            child: FittedBox(
                              child: Text(
                                "${context.read<Auth>().user.email}",
                                style: TextStyle(color: Colors.grey, fontSize: 60, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ))))),
          ],
        ),
      ),
    );
  }
}
