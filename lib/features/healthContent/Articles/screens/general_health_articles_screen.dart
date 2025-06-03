import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/core/widgets/error_screen.dart';
import 'package:food_lens/features/healthContent/Articles/cubit/general_health_cubit.dart';
import 'package:food_lens/features/healthContent/Articles/cubit/general_health_state.dart';
import 'package:food_lens/features/healthContent/Articles/repository/articles_health_repository.dart';
import 'package:food_lens/features/healthContent/Articles/widgets/article_item.dart';
import 'package:food_lens/core/widgets/pagination_controls.dart';

class GeneralHealthArticlesScreen extends StatelessWidget {
  final bool hasChronicDiseases;
   const GeneralHealthArticlesScreen({super.key , required this.hasChronicDiseases});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GeneralHealArticlesthCubit(repository: ArticlesRepository())..fetchArticles(hasChronicDiseases),
      child: _GeneralHealthArticlesScreenContent(hasChronicDiseases:hasChronicDiseases ),
    );
  }
}

class _GeneralHealthArticlesScreenContent extends StatefulWidget {
    final bool hasChronicDiseases;

  const _GeneralHealthArticlesScreenContent({required this.hasChronicDiseases});

  @override
  _GeneralHealthArticlesScreenContentState createState() =>
      _GeneralHealthArticlesScreenContentState();
}

class _GeneralHealthArticlesScreenContentState
    extends State<_GeneralHealthArticlesScreenContent> {
  late ScrollController _scrollController;
  int _lastPage = -1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<GeneralHealArticlesthCubit>();
    return BlocConsumer<GeneralHealArticlesthCubit, GeneralHealthState>(
      listener: (context, state) {
        if (state.currentPage != _lastPage) {
          _scrollToTop();
          _lastPage = state.currentPage;
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await articlesCubit.fetchArticles(widget.hasChronicDiseases);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverAppBar(
                floating: true,
                snap: true,
                title: Text('Articles'),
              ),
              SliverToBoxAdapter(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GeneralHealthState state) {
    switch (state.status) {
      case ArticleStatus.initial:
      case ArticleStatus.loading:
        return const SizedBox(
          height: 600,
          child: Center(child: CircularProgressIndicator()),
        );
      case ArticleStatus.success:
        return Column(
          children: [
            ListView.builder(
              itemCount: state.paginatedArticles.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ArticleItem(article: state.paginatedArticles[index]);
              },
            ),
            PaginationControls(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              itemsPerPage: state.itemsPerPage,
              totalItems: state.articles.length,
              onFirstPage:
                  () =>
                      context
                          .read<GeneralHealArticlesthCubit>()
                          .goToFirstPage(),
              onPreviousPage:
                  () =>
                      context
                          .read<GeneralHealArticlesthCubit>()
                          .goToPreviousPage(),
              onNextPage:
                  () =>
                      context.read<GeneralHealArticlesthCubit>().goToNextPage(),
              onLastPage:
                  () =>
                      context.read<GeneralHealArticlesthCubit>().goToLastPage(),
            ),
          ],
        );

      case ArticleStatus.failure:
        return ErrorScreen(
          errorMessage: state.errorMessage,
          onRetry:
              () => context.read<GeneralHealArticlesthCubit>().fetchArticles(widget.hasChronicDiseases),
        );
    }
  }
}
