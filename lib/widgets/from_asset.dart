import 'package:academy_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class PlayVideoFromAsset extends StatefulWidget {
  const PlayVideoFromAsset({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromAsset> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<PlayVideoFromAsset> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/SampleVideo_720x480_20mb.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Consumer<Auth>(
                    builder: (context, authData, child) {
                      final user = authData.user;
                      return Transform.rotate(
                        angle: -0.45,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.2,
                            child: Text(
                              user.email!,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 60,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
