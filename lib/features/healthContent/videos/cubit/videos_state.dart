import 'package:equatable/equatable.dart';
import 'package:food_lens/features/healthContent/videos/model/video_model.dart';

enum VideoStatus { initial, loading, success, failure }
class VideosState extends Equatable {
  final List<VideoModel> allVideos;
  final List<VideoModel> currentPageVideos;
  final int currentPage;
  final int itemsPerPage;
  final VideoStatus status;
  final String? errorMessage;

  const VideosState({
    this.allVideos = const [],
    this.currentPageVideos = const [],
    this.currentPage = 0,
    this.itemsPerPage = 20,
    this.status = VideoStatus.initial,
    this.errorMessage,
  });

  int get totalPages => ((allVideos.length - 1) ~/ itemsPerPage) + 1;

  VideosState copyWith({
    List<VideoModel>? allVideos,
    List<VideoModel>? currentPageVideos,
    int? currentPage,
    int? totalPages,
    int? itemsPerPage,
    VideoStatus? status,
    String? errorMessage,
    bool? showPagination,
  }) {
    return VideosState(
      allVideos: allVideos ?? this.allVideos ,
      currentPageVideos: currentPageVideos ?? this.currentPageVideos,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allVideos,
        currentPageVideos,
        currentPage,
        itemsPerPage,
        status,
        errorMessage,
      ];
}
