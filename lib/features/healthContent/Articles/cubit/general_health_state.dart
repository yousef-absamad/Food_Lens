import 'package:food_lens/features/healthContent/Articles/model/general_health_article.dart';

enum ArticleStatus { initial, loading, success, failure }

class GeneralHealthState {
  final List<ArticlesModel> articles;
  final String? errorMessage;
  final int currentPage;
  final int itemsPerPage;
  final ArticleStatus status;

  const GeneralHealthState({
    this.articles = const [],
    this.errorMessage,
    this.currentPage = 0,
    this.itemsPerPage = 20,
    this.status = ArticleStatus.initial,
  });

  List<ArticlesModel> get paginatedArticles {
    final start = currentPage * itemsPerPage;
    final end = (currentPage + 1) * itemsPerPage;
    return articles.sublist(
      start,
      end > articles.length ? articles.length : end,
    );
  }

  int get totalPages => ((articles.length - 1) ~/ itemsPerPage) + 1;

  GeneralHealthState copyWith({
    List<ArticlesModel>? articles,
    String? errorMessage,
    int? currentPage,
    int? itemsPerPage,
    ArticleStatus? status,
  }) {
    return GeneralHealthState(
      articles: articles ?? this.articles,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      status: status ?? this.status,
    );
  }
}
