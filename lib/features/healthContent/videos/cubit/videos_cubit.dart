import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_state.dart';
import 'package:food_lens/features/healthContent/videos/model/video_model.dart';
import 'package:food_lens/features/healthContent/videos/repository/video_repository.dart';

class VideosCubit extends Cubit<VideosState> {
  final VideoRepository videoRepository;
  VideosCubit(this.videoRepository) : super(const VideosState());

  final Random _random = Random();

  Future<void> initializePlaylistAndFetchVideos(bool hasChronicDiseases) async {
    if (isClosed) return;

    emit(state.copyWith(status: VideoStatus.loading));

    try {
      String playlistId = await videoRepository.fetchPlaylistId(
        language: "ar",
        hasChronicDiseases: hasChronicDiseases,
      );

      List<VideoModel> allVideos = [];
      String? nextPageToken;

      do {
        final result = await videoRepository.fetchVideosFromPlaylist(
          playlistId,
          pageToken: nextPageToken,
        );

        if (isClosed) return;

        allVideos.addAll(result['videos']);
        nextPageToken = result['nextPageToken'];
      } while (nextPageToken != null);

      if (isClosed) return;

      allVideos.shuffle(_random);

      emit(
        state.copyWith(
          allVideos: allVideos,
          currentPage: 0,
          currentPageVideos: _getCurrentPageVideos(
            allVideos,
            0,
            state.itemsPerPage,
          ),
          status: VideoStatus.success,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: VideoStatus.failure,
            errorMessage:
                "Failed to load videos.\n Check your internet connection.",
          ),
        );
      }
    }
  }

  List<VideoModel> _getCurrentPageVideos(
    List<VideoModel> allVideos,
    int currentPage,
    int itemsPerPage,
  ) {
    final start = currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, allVideos.length);
    return allVideos.sublist(start, end);
  }

  void goToNextPage() {
    final nextPage = state.currentPage + 1;
    if (nextPage < state.totalPages) {
      emit(
        state.copyWith(
          currentPage: nextPage,
          currentPageVideos: _getCurrentPageVideos(
            state.allVideos,
            nextPage,
            state.itemsPerPage,
          ),
        ),
      );
    }
  }

  void goToPreviousPage() {
    final prevPage = state.currentPage - 1;
    if (prevPage >= 0) {
      emit(
        state.copyWith(
          currentPage: prevPage,
          currentPageVideos: _getCurrentPageVideos(
            state.allVideos,
            prevPage,
            state.itemsPerPage,
          ),
        ),
      );
    }
  }

  void goToFirstPage() {
    emit(
      state.copyWith(
        currentPage: 0,
        currentPageVideos: _getCurrentPageVideos(
          state.allVideos,
          0,
          state.itemsPerPage,
        ),
      ),
    );
  }

  void goToLastPage() {
    final lastPage = state.totalPages - 1;
    emit(
      state.copyWith(
        currentPage: lastPage,
        currentPageVideos: _getCurrentPageVideos(
          state.allVideos,
          lastPage,
          state.itemsPerPage,
        ),
      ),
    );
  }
}
