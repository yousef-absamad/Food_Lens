import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_lens/core/constans/constans.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/error_screen.dart';

class GeneralHealthNewsPage extends StatefulWidget {
  const GeneralHealthNewsPage({super.key});

  @override
  GeneralHealthNewsPageState createState() => GeneralHealthNewsPageState();
}

class GeneralHealthNewsPageState extends State<GeneralHealthNewsPage> {
  List<dynamic> _newsList = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 0;
  final int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse(Constants.generalHealthNews);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fetchedNews = data['news'] ?? [];

        setState(() {
          _newsList = List.from(fetchedNews)..shuffle();
          _isLoading = false;
          _currentPage = 0; // نبدأ من أول صفحة
        });
      } else {
        setState(() {
          _errorMessage = 'Error loading data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while fetching articles';
        _isLoading = false;
      });
      // إذا كانت القائمة تحتوي على بيانات سابقة، لا نفرغها
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cannot open the link: $url')));
      }
    }
  }

  List<dynamic> get _paginatedNews {
    final start = _currentPage * _itemsPerPage;
    final end = (_currentPage + 1) * _itemsPerPage;
    return _newsList.sublist(
      start,
      end > _newsList.length ? _newsList.length : end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchNews();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Text('General Health News'),
                centerTitle: true,
              ),
              SliverToBoxAdapter(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _newsList.isEmpty) {
      // فقط إذا لم تكن هناك بيانات مخزنة
      return SizedBox(
        height: 600,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    // إذا كان هناك خطأ ولا توجد بيانات مخزنة، نعرض ErrorScreen
    if (_errorMessage != null) {
      return ErrorScreen(errorMessage: _errorMessage, onRetry: fetchNews);
    }

    if (_newsList.isEmpty) {
      return const Center(child: Text('No news available at the moment'));
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _paginatedNews.length,
          itemBuilder: (context, index) {
            final item = _paginatedNews[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: InkWell(
                onTap: () => _launchURL(item['url']),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['imageUrl'],
                          width: 120,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 120,
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed:
                    _currentPage > 0
                        ? () {
                          setState(() {
                            _currentPage = 0;
                          });
                        }
                        : null,
                icon: const Icon(Icons.first_page, size: 30),
                tooltip: 'First Page',
              ),
              IconButton(
                onPressed:
                    _currentPage > 0
                        ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                        : null,
                icon: const Icon(Icons.arrow_back, size: 30),
                tooltip: 'Previous Page',
              ),
              Text(
                'Page ${_currentPage + 1} of ${((_newsList.length - 1) ~/ _itemsPerPage) + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed:
                    (_currentPage + 1) * _itemsPerPage < _newsList.length
                        ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                        : null,
                icon: const Icon(Icons.arrow_forward, size: 30),
                tooltip: 'Next Page',
              ),
              IconButton(
                onPressed:
                    (_currentPage + 1) * _itemsPerPage < _newsList.length
                        ? () {
                          setState(() {
                            _currentPage =
                                ((_newsList.length - 1) ~/ _itemsPerPage);
                          });
                        }
                        : null,
                icon: const Icon(Icons.last_page, size: 30),
                tooltip: 'Last Page',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
