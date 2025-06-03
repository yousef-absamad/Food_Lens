import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebViewScreen extends StatefulWidget {
  final String url;

  const ArticleWebViewScreen({super.key, required this.url});

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}
class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  String _ensureUrlHasScheme(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url'; 
    }
    return url;
  }

  @override
  void initState() {
    super.initState();
    final validUrl = _ensureUrlHasScheme(widget.url);
    controller = WebViewController()
      ..loadRequest(Uri.parse(validUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
