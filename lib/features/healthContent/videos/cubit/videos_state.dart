import 'package:equatable/equatable.dart';

enum VideoStatus { initial, loading, success, failure }

class VideosState extends Equatable {
  final List<Map<String, String>> allVideos;
  final List<Map<String, String>> currentPageVideos;
  final int currentPage;
  final VideoStatus status;
  final String? errorMessage;
  final bool showPagination;

  const VideosState({
    this.allVideos = const [],
    this.currentPageVideos = const [],
    this.currentPage = 0,
    this.status = VideoStatus.initial,
    this.errorMessage,
    this.showPagination = false,
  });

  VideosState copyWith({
    List<Map<String, String>>? allVideos,
    List<Map<String, String>>? currentPageVideos,
    int? currentPage,
    VideoStatus? status,
    String? errorMessage,
    bool? showPagination,
  }) {
    return VideosState(
      allVideos: allVideos ?? this.allVideos,
      currentPageVideos: currentPageVideos ?? this.currentPageVideos,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      showPagination: showPagination ?? this.showPagination,
    );
  }

  @override
  List<Object?> get props => [
    allVideos,
    currentPageVideos,
    currentPage,
    status,
    errorMessage,
    showPagination,
  ];
}