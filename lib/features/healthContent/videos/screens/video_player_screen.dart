
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({required this.videoId, super.key});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  void _rewind10Seconds() {
    final currentPosition = _controller.value.position.inSeconds;
    _controller.seekTo(Duration(seconds: max(0, currentPosition - 10)));
  }

  void _forward10Seconds() {
    final currentPosition = _controller.value.position.inSeconds;
    _controller.seekTo(Duration(seconds: currentPosition + 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _controller.value.isFullScreen
              ? null
              : AppBar(title: const Text("Video Player")),
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
              onReady: () {
                print("Player is ready");
              },
              onEnded: (metaData) {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.replay_10,
                    color: Colors.red,
                    size: 40,
                  ),
                  onPressed: _rewind10Seconds,
                ),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.red,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.forward_10,
                    color: Colors.red,
                    size: 40,
                  ),
                  onPressed: _forward10Seconds,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
