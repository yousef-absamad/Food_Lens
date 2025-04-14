import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/healthContent/Articles/cubit/general_health_state.dart';
import 'package:food_lens/features/healthContent/Articles/repository/articles_health_repository.dart';

class GeneralHealArticlesthCubit extends Cubit<GeneralHealthState> {
  final ArticlesRepository repository;
  GeneralHealArticlesthCubit({required this.repository})
    : super(const GeneralHealthState());

  Future<void> fetchArticles() async {
    emit(state.copyWith(errorMessage: null, status: ArticleStatus.loading));

    try {
      final articles = await repository.fetchArticles(
        language: 'en',
        isChronic: true,
      );
      emit(
        state.copyWith(
          articles: articles,
          currentPage: 0,
          errorMessage: null,
          status: ArticleStatus.success,
        ),
      );
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
