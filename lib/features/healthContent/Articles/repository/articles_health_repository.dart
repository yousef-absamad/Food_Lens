import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_lens/core/constans/constans.dart';
import 'package:food_lens/features/healthContent/Articles/model/general_health_article.dart';

class ArticlesRepository {
  Future<List<ArticlesModel>> fetchArticles({
    required String language,
    required bool isChronic,
  }) async {
    try {
      //final endpoint ='${Constants.articlesBaseUrl}${Constants.enChronicArticles}.json';
      final endpoint = '${Constants.articlesBaseUrl}/$language${isChronic ? '/chronic' : '/normal'}.json';

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == null || data.isEmpty) return [];

        List<ArticlesModel> articles = [];
        data.forEach((key, value) {
          articles.add(ArticlesModel.fromJson(value));
        });

        return articles..shuffle();
      } else {
        throw Exception('Error loading data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }
}
