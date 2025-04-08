import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_cubit.dart';
import 'package:food_lens/features/healthContent/videos/cubit/videos_state.dart';
import 'package:food_lens/features/healthContent/videos/screens/video_player_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      context.read<VideosCubit>().updatePaginationVisibility(
        _scrollController.position.pixels,
        _scrollController.position.maxScrollExtent,
      );
    });
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosCubit, VideosState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh:
              () => context
                  .read<VideosCubit>()
                  .initializePlaylistAndFetchVideos(widget.userCondition),
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
              _buildBody(context, state),
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
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      case VideoStatus.success:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < state.currentPageVideos.length) {
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
                              return const SizedBox(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "Failed to load image",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
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
              } else if (index == state.currentPageVideos.length &&
                  state.showPagination) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed:
                            state.currentPage > 0
                                ? () =>
                                    context.read<VideosCubit>().previousPage()
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
                            (state.currentPage + 1) * 20 <
                                    state.allVideos.length
                                ? () => context.read<VideosCubit>().nextPage()
                                : null,
                        icon: const Icon(Icons.arrow_forward, size: 35),
                        tooltip: 'Next Page',
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 10);
            },
            childCount:
                state.currentPageVideos.length +
                (state.showPagination ? 1 : 0) +
                1,
          ),
        );
      case VideoStatus.failure:
        return SliverFillRemaining(
        hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/image/404 Error-amico.svg"),
                Text(
                  state.errorMessage ?? "An unknown error occurred",
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      () => context
                          .read<VideosCubit>()
                          .initializePlaylistAndFetchVideos(
                            widget.userCondition,
                          ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
