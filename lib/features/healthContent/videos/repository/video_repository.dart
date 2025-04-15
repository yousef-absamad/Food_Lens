import 'dart:convert';

import 'package:food_lens/core/constans/constans.dart';
import 'package:food_lens/features/healthContent/videos/model/video_model.dart';
import 'package:http/http.dart' as http;

class VideoRepository {
  VideoRepository();

  Future<String> fetchPlaylistId({
    required String language,
    required bool isChronic,
  }) async {
    final String endpoint = '${Constants.videosBaseUrl}/$language${isChronic ? '/chronic' : '/normal'}.json';
    //final String endpoint = '${Constants.videosBaseUrl}/ar${isChronic ? '/chronic' : '/normal'}.json';
    //final String endpoint = 'https://food-lens-1d706-default-rtdb.firebaseio.com/videos/ar/chronic.json';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      try {
        final playlistId = data["playlistId"];
        if (playlistId != null) {
          return playlistId;
          //return "PL9MfvCxhfaCRu1o08I8SNuNULIN2Er3XN";
        } else {
          throw Exception('Playlist ID not found');
        }
      } catch (e) {
        throw Exception('Error parsing playlist ID: $e');
      }
    } else {
      throw Exception('Failed to load playlist ID');
    }
  }

  Future<Map<String, dynamic>> fetchVideosFromPlaylist(
    String playlistId, {
    String? pageToken,
  }) async {
    String url =
        "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&maxResults=50&key=${Constants.youtubeApiKey}";

    if (pageToken != null) {
      url += "&pageToken=$pageToken";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<VideoModel> videos = [];
      for (var item in data['items']) {
      try {
        videos.add(VideoModel.fromJson(item));
      } catch (e) {
        //throw Exception('Failed to convert video to VideoModel');
      }
    }
      return {'videos': videos, 'nextPageToken': data['nextPageToken']};
    } else {
      throw Exception('Failed to load videos');
    }
   }
}
