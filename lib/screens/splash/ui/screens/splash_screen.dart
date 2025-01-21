import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class AnimationSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GifView.asset(
          'assets/videos/splash_video.gif',
          frameRate: 30, 
        ),
      ),
    );
  }
}
