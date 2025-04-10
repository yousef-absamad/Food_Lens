import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/healthContent/Articles/cubit/general_health_state.dart';
import 'package:food_lens/features/healthContent/Articles/model/general_health_article.dart';
import 'package:http/http.dart' as http;
import 'package:food_lens/core/constans/constans.dart';

class GeneralHealArticlesthCubit extends Cubit<GeneralHealthState> {
  GeneralHealArticlesthCubit() : super(const GeneralHealthState());

  Future<void> fetchArticles() async {
    emit(
      state.copyWith(
        errorMessage: null,
        status: ArticleStatus.loading,
      ),
    );

    try {
      final response = await http.get(Uri.parse(Constants.generalHealthNews));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> newsJson = data['news'] ?? [];

        List<GeneralHealthArticle> articles =
            newsJson
                .map((json) => GeneralHealthArticle.fromJson(json))
                .toList();

        articles.shuffle();

        emit(
          state.copyWith(
            articles: articles,
            currentPage: 0,
            errorMessage: null,
            status: ArticleStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: 'Error loading data: ${response.statusCode}',
            status: ArticleStatus.failure,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage:
              'An error occurred while fetching articles. \nCheck your internet connection. ',
          status: ArticleStatus.failure,
        ),
      );
    }
  }

  void goToFirstPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: 0));
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void goToNextPage() {
    if ((state.currentPage + 1) * state.itemsPerPage < state.articles.length) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void goToLastPage() {
    final lastPage = ((state.articles.length - 1) ~/ state.itemsPerPage);
    if (state.currentPage < lastPage) {
      emit(state.copyWith(currentPage: lastPage));
    }
  }
}
