class VideoModel {
  final String title;
  final String videoId;
  final String thumbnailUrl;

  VideoModel({
    required this.title,
    required this.videoId,
    required this.thumbnailUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['snippet']['title'],
      videoId: json['snippet']['resourceId']['videoId'],
      thumbnailUrl: json['snippet']['thumbnails']['medium']['url'],
    );
  }
}
