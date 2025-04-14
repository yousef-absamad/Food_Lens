class ArticlesModel {
  final String title;
  final String imageUrl;
  final String url;

  ArticlesModel({
    required this.title,
    required this.imageUrl,
    required this.url,
  });

  factory ArticlesModel.fromJson(Map<String, dynamic> json) {
    return ArticlesModel(
      title: json['title'] ?? 'No title',
      imageUrl: json['imageUrl'] ?? '',
      url: json['articleUrl'] ?? '',
    );
  }
}