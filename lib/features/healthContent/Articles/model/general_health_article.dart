class GeneralHealthArticle {
  final String title;
  final String imageUrl;
  final String url;

  GeneralHealthArticle({
    required this.title,
    required this.imageUrl,
    required this.url,
  });

  factory GeneralHealthArticle.fromJson(Map<String, dynamic> json) {
    return GeneralHealthArticle(
      title: json['title'] ?? 'No title',
      imageUrl: json['imageUrl'] ?? '',
      url: json['url'] ?? '',
    );
  }
}