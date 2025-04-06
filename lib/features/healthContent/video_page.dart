import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class VideoPage extends StatefulWidget {
  final String userCondition;

  const VideoPage({required this.userCondition, super.key});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  late Future<List<Map<String, String>>> _videosFuture;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _videosFuture = _fetchVideosForCondition();
  }

  Future<String> getPlaylistId(String condition) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('playlists')
            .doc(condition)
            .get();

    if (doc.exists) {
      return doc['playlistId'] as String;
    } else {
      throw Exception('No playlist found for this condition');
    }
  }

  Future<List<Map<String, String>>> fetchPlaylistVideos(
    String playlistId,
  ) async {
    const String apiKey = "AIzaSyAQJs724qclwBt4R9UYATz9YaL83PNqyWQ";
    final String url =
        "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&maxResults=50&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> videos = [];

      for (var item in data['items']) {
        String title = item['snippet']['title'];
        String videoId = item['snippet']['resourceId']['videoId'];
        String thumbnail = item['snippet']['thumbnails']['medium']['url'];

        videos.add({
          'title': title,
          'videoId': videoId,
          'thumbnail': thumbnail,
        });
      }
      return videos;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Future<List<Map<String, String>>> _fetchVideosForCondition() async {
    String playlistId = await getPlaylistId(widget.userCondition);
    List<Map<String, String>> videos = await fetchPlaylistVideos(playlistId);
    videos.shuffle(_random); // خلط الفيديوهات عشوائياً
    return videos;
  }

  Future<void> _refreshVideos() async {
    setState(() {
      _videosFuture = _fetchVideosForCondition();
    });
  }

  void playVideo(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoId: videoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Videos for ${widget.userCondition}")),
      body: RefreshIndicator(
        onRefresh: _refreshVideos,
        child: FutureBuilder<List<Map<String, String>>>(
          future: _videosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No videos found"));
            }

            final videos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return GestureDetector(
                  onTap: () => playVideo(video['videoId']!),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            video['thumbnail']!,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // الصورة ظهرت تمامًا
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(12),
                        //   child: CachedNetworkImage(
                        //     imageUrl: video['thumbnail']!,
                        //     placeholder:
                        //         (context, url) => Container(
                        //           height: 200,
                        //           color: Colors.grey[300],
                        //           child: const Center(
                        //             child: CircularProgressIndicator(),
                        //           ),
                        //         ),
                        //     errorWidget:
                        //         (context, url, error) => Container(
                        //           height: 200,
                        //           color: Colors.grey[300],
                        //           child: const Center(child: Icon(Icons.error)),
                        //         ),
                        //     fit: BoxFit.cover,
                        //     height: 200,
                        //     width: double.infinity,
                        //     fadeInDuration: const Duration(
                        //       milliseconds: 300,
                        //     ), // تسريع التحميل
                        //     placeholderFadeInDuration: const Duration(
                        //       milliseconds: 200,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            video['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoId;

  const VideoPlayerPage({required this.videoId, super.key});

  @override
  VideoPlayerPageState createState() => VideoPlayerPageState();
}

class VideoPlayerPageState extends State<VideoPlayerPage> {
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
