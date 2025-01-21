import 'dart:async';
import 'dart:convert';

import 'package:academy_app/providers/auth.dart';
import 'package:double_tap_player_view/double_tap_player_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../constants.dart';
import '../providers/my_courses.dart';
import '../providers/shared_pref_helper.dart';

class PlayVideoFromNetwork extends StatefulWidget {
  static const routeName = '/fromNetwork';
  final int courseId;
  final int? lessonId;
  final String videoUrl;

  const PlayVideoFromNetwork({
    Key? key,
    required this.courseId,
    this.lessonId,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromNetworkState();
}

class _PlayVideoFromNetworkState extends State<PlayVideoFromNetwork> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  Timer? _timer;
  bool _isFullScreen = false; 
  @override
  void initState() {
    super.initState();
        controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(
          widget.videoUrl
          // videoUrls: [
          //   VideoQalityUrls(
          //     quality: 360,
          //     url: widget.videoUrl,
          //   ),
          //   VideoQalityUrls(
          //     quality: 720,
          //     url: widget.videoUrl,
          //   ),
          // ],
        ),
        watermark:Center(child: _buildWatermark()))
      ..initialise();
    super.initState();

    if (widget.lessonId != null) {
      timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => _updateWatchHistory());
    }

    _initializeVideoPlayer();
    if (widget.lessonId != null) {
      _startWatchHistoryUpdater();
    }
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,  
      allowPlaybackSpeedChanging: true,
      allowMuting: true,
      zoomAndPan: false, // نغلق هذه الميزة لأننا سنستخدم مكتبة `zoom_widget` للزووم
      overlay: Center(child: _buildWatermark()),
    );
  }

  Widget _buildWatermark() {
    return Consumer<Auth>(
      builder: (context, authData, child) {
        final user = authData.user;
        return IgnorePointer(
          child: Opacity(
            opacity: 0.3,
            child: Text(
              user.email ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 60,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  void _startWatchHistoryUpdater() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _updateWatchHistory(),
    );
  }

  Future<void> _updateWatchHistory() async {
    if (_videoPlayerController.value.isPlaying) {
      try {
        final token = await SharedPreferenceHelper().getAuthToken();
        if (token != null && token.isNotEmpty) {
          final response = await http.post(
            Uri.parse("$BASE_URL/api/update_watch_history/$token"),
            body: {
              'course_id': widget.courseId.toString(),
              'lesson_id': widget.lessonId.toString(),
              'current_duration': _videoPlayerController.value.position.inSeconds.toString(),
            },
          );

          final responseData = json.decode(response.body);
          if (responseData['is_completed'] == 1) {
            Provider.of<MyCourses>(context, listen: false).updateDripContendLesson(
              widget.courseId,
              responseData['course_progress'],
              responseData['number_of_completed_lessons'],
            );
          }
        }
      } catch (error) {
        debugPrint("Error updating watch history: $error");
      }
    }
  }

  void _forwardVideo() {
    final currentPosition = _videoPlayerController.value.position;
    final duration = _videoPlayerController.value.duration;

    final newPosition = currentPosition + const Duration(seconds: 10);
    if (newPosition < duration) {
      _videoPlayerController.seekTo(newPosition);
    } else {
      _videoPlayerController.seekTo(duration);
    }
  }

  void _rewindVideo() {
    final currentPosition = _videoPlayerController.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _videoPlayerController.seekTo(newPosition);
    } else {
      _videoPlayerController.seekTo(Duration.zero);
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        // تفعيل الشاشة الكاملة
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,  // هنا بنفعل الشاشة الكاملة
          allowPlaybackSpeedChanging: true,
          allowMuting: true,
          zoomAndPan: false,  // نغلق التكبير اليدوي من Chewie لأنه سيتم عبر zoom_widget
          overlay: _buildWatermark(),
        );
      } else {
        // العودة إلى وضع الشاشة العادية
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          allowFullScreen: false,
          allowPlaybackSpeedChanging: true,
          allowMuting: true,
          zoomAndPan: false,  // نغلق التكبير اليدوي من Chewie لأنه سيتم عبر zoom_widget
          overlay: _buildWatermark(),
        );
      }
    });
  }

  void _pausePlayVideo() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool isServerOne = true;
  late final PodPlayerController controller;
  Timer? timer;

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
    body: SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: (){
                  setState(() {
                    isServerOne = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isServerOne ?Colors.blue : Colors.blueGrey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Server One' ,  style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              SizedBox(width: 30,),
              InkWell(
                onTap: (){
                  setState(() {
                    isServerOne = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isServerOne ? Colors.blueGrey : Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Server Two' , style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),

       
        
                    SizedBox(height: 40,),

         isServerOne ?    PodVideoPlayer(
            controller: controller,
            podProgressBarConfig: const PodProgressBarConfig(
              padding: kIsWeb
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
              playingBarColor: Colors.blue,
              circleHandlerColor: Colors.blue,
              backgroundColor: Colors.blueGrey,
            ),
          ) : AspectRatio( aspectRatio: 16/9,child: Chewie(controller: _chewieController)),
        ],
      ),
    ),
  );
}
  Widget _overlay(SwipeData data) {
    final dxDiff = (data.currentDx - data.startDx).toInt();
    final diffDuration = Duration(seconds: dxDiff);
    final prefix = diffDuration.isNegative ? '-' : '+';
    final positionText = '$prefix${diffDuration.printDuration()}';
    return Center(
      child: Text(
        positionText,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}

extension on Duration {
  String printDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.abs().remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.abs().remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
