import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/core/constans/constans.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_state.dart';
import 'package:http/http.dart' as http;

class VideosCubit extends Cubit<VideosState> {
  VideosCubit() : super(const VideosState());

  final String apiKey = Constants.youtubeApiKey;
  late String _playlistId;
  String? _nextPageToken;
  final int _maxResultsPerPage = 20;
  final int _pageSize = 20;
  final Random _random = Random();

  Future<void> initializePlaylistAndFetchVideos(String userCondition) async {
    emit(state.copyWith(status: VideoStatus.loading));
    try {
      _playlistId = await _getPlaylistId(userCondition);

      List<Map<String, String>> allVideos = [];
      String? nextPageToken;

      do {
        final videos = await _fetchPlaylistVideos(
          //playlistId: _playlistId,
          playlistId: "PLqbUw5kmg6AHY6eE1VuPaPLSRejkkaTrb",
          pageToken: nextPageToken,
        );
        allVideos.addAll(videos);
        nextPageToken = _nextPageToken;
      } while (nextPageToken != null);

      allVideos.shuffle(_random);

      emit(
        state.copyWith(
          allVideos: allVideos,
          currentPageVideos: _getCurrentPageVideos(allVideos, 0),
          status: VideoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoStatus.failure,
          errorMessage:
              e.toString() == "Exception: No playlist found for this condition"
                  ? "No videos available for this condition."
                  : "Failed to load videos.\n Check your internet connection.",
        ),
      );
    }
  }

  Future<String> _getPlaylistId(String condition) async {
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

  Future<List<Map<String, String>>> _fetchPlaylistVideos({
    required String playlistId,
    String? pageToken,
  }) async {
    String url =
        "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&maxResults=$_maxResultsPerPage&key=$apiKey";

    if (pageToken != null) {
      url += "&pageToken=$pageToken";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _nextPageToken = data['nextPageToken'];

      List<Map<String, String>> videos = [];
      for (var item in data['items']) {
        videos.add({
          'title': item['snippet']['title'],
          'videoId': item['snippet']['resourceId']['videoId'],
          'thumbnail': item['snippet']['thumbnails']['medium']['url'],
        });
      }
      videos.shuffle(_random);
      return videos;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  

  List<Map<String, String>> _getCurrentPageVideos(
    List<Map<String, String>> allVideos,
    int currentPage,
  ) {
    final start = currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, allVideos.length);
    return allVideos.sublist(start, end);
  }

  void nextPage() {
    if ((state.currentPage + 1) * _pageSize < state.allVideos.length) {
      final newPage = state.currentPage + 1;
      emit(
        state.copyWith(
          currentPage: newPage,
          currentPageVideos: _getCurrentPageVideos(state.allVideos, newPage),
        ),
      );
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      final newPage = state.currentPage - 1;
      emit(
        state.copyWith(
          currentPage: newPage,
          currentPageVideos: _getCurrentPageVideos(state.allVideos, newPage),
        ),
      );
    }
  }

  

  void goToFirstPage() {
    final newPage = 0;
    emit(
      state.copyWith(
        currentPage: newPage,
        currentPageVideos: _getCurrentPageVideos(state.allVideos, newPage),
      ),
    );
  }

  void goToLastPage() {
    final lastPage = ((state.allVideos.length - 1) ~/ _pageSize);
    emit(
      state.copyWith(
        currentPage: lastPage,
        currentPageVideos: _getCurrentPageVideos(state.allVideos, lastPage),
      ),
    );
  }
}
