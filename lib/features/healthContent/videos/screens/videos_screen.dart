import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_cubit.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_state.dart';
import 'package:food_lens/features/healthContent/videos/screens/video_player_screen.dart';

import '../../../../core/widgets/error_screen.dart';

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
    final videosCubit = context.read<VideosCubit>();
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
                return GestureDetector(
                  onTap: () => playVideo(video['videoId']!),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            video['thumbnail']!,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                height: 200,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            video['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                        state.currentPage > 0
                            ? () => videosCubit.goToFirstPage()
                            : null,
                    icon: const Icon(Icons.first_page, size: 35),
                    tooltip: 'First Page',
                  ),
                  IconButton(
                    onPressed:
                        state.currentPage > 0
                            ? () => videosCubit.previousPage()
                            : null,
                    icon: const Icon(Icons.arrow_back, size: 35),
                    tooltip: 'Previous Page',
                  ),
                  Text(
                    'Page ${state.currentPage + 1} of ${((state.allVideos.length - 1) ~/ 20) + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        (state.currentPage + 1) * 20 < state.allVideos.length
                            ? () => videosCubit.nextPage()
                            : null,
                    icon: const Icon(Icons.arrow_forward, size: 35),
                    tooltip: 'Next Page',
                  ),
                  IconButton(
                    onPressed:
                        (state.currentPage + 1) * 20 < state.allVideos.length
                            ? () => videosCubit.goToLastPage()
                            : null,
                    icon: const Icon(Icons.last_page, size: 35),
                    tooltip: 'Last Page',
                  ),
                ],
              ),
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
