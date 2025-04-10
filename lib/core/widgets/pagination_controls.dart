import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;
  final int totalItems;

  final VoidCallback? onFirstPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onLastPage;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.totalItems,
    this.onFirstPage,
    this.onPreviousPage,
    this.onNextPage,
    this.onLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 0 ? onFirstPage : null,
            icon: const Icon(Icons.first_page, size: 30),
            tooltip: 'First Page',
          ),
          IconButton(
            onPressed: currentPage > 0 ? onPreviousPage : null,
            icon: const Icon(Icons.arrow_back, size: 30),
            tooltip: 'Previous Page',
          ),
          Text(
            'Page ${currentPage + 1} of $totalPages',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: (currentPage + 1) * itemsPerPage < totalItems ? onNextPage : null,
            icon: const Icon(Icons.arrow_forward, size: 30),
            tooltip: 'Next Page',
          ),
          IconButton(
            onPressed: (currentPage + 1) * itemsPerPage < totalItems ? onLastPage : null,
            icon: const Icon(Icons.last_page, size: 30),
            tooltip: 'Last Page',
          ),
        ],
      ),
    );
  }
}
