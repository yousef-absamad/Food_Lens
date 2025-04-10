import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_cubit.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_state.dart';
import 'package:food_lens/features/healthContent/videos/screens/video_player_screen.dart';

import '../../../../core/widgets/error_screen.dart';
import '../../../../core/widgets/pagination_controls.dart';
import '../widgets/video_card.dart';

class VideosScreen extends StatelessWidget {
  final String userCondition;

  const VideosScreen({required this.userCondition, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              VideosCubit()..initializePlaylistAndFetchVideos(userCondition),
      child: _VideosScreenContent(userCondition: userCondition),
    );
  }
}

class _VideosScreenContent extends StatefulWidget {
  final String userCondition;

  const _VideosScreenContent({required this.userCondition});

  @override
  _VideosScreenContentState createState() => _VideosScreenContentState();
}

class _VideosScreenContentState extends State<_VideosScreenContent> {
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

  void playVideo(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoId: videoId),
      ),
    );
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
    final videosCubit = context.read<VideosCubit>();
    return BlocConsumer<VideosCubit, VideosState>(
      listener: (context, state) {
        if (state.status == VideoStatus.success &&
            state.currentPage != _lastPage) {
          _scrollToTop();
          _lastPage = state.currentPage;
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await videosCubit.initializePlaylistAndFetchVideos(
              widget.userCondition,
            );
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text("Videos for ${widget.userCondition}"),
                floating: true,
                snap: true,
                pinned: false,
              ),
              SliverToBoxAdapter(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, VideosState state) {
    switch (state.status) {
      case VideoStatus.initial:
      case VideoStatus.loading:
        return SizedBox(
          height: 600,
          child: const Center(child: CircularProgressIndicator()),
        );
      case VideoStatus.success:
        return Column(
          children: [
            ListView.builder(
              itemCount: state.currentPageVideos.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final video = state.currentPageVideos[index];
                return VideoCard(
                  videoId: video['videoId']!,
                  title: video['title']!,
                  thumbnail: video['thumbnail']!,
                  onTap: playVideo,
                );
              },
            ),
            PaginationControls(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              itemsPerPage: state.itemsPerPage,
              totalItems: state.allVideos.length,
              onFirstPage: () => context.read<VideosCubit>().goToFirstPage(),
              onPreviousPage:
                  () => context.read<VideosCubit>().goToPreviousPage(),
              onNextPage: () => context.read<VideosCubit>().goToNextPage(),
              onLastPage: () => context.read<VideosCubit>().goToLastPage(),
            ),
           
          ],
        );
      case VideoStatus.failure:
        return ErrorScreen(
          errorMessage: state.errorMessage ?? "An unknown error occurred",
          onRetry:
              () => context
                  .read<VideosCubit>()
                  .initializePlaylistAndFetchVideos(widget.userCondition),
        );
    }
  }
}