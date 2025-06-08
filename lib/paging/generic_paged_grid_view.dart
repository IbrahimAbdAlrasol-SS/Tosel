import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

typedef FetchPage<T> = Future<ApiResponse<T>> Function(int pageKey);

class GenericPagedGridView<T> extends StatefulWidget {
  final FetchPage<T> fetchPage;
  final ItemBuilder<T> itemBuilder;
  final SliverGridDelegate gridDelegate;
  final int pageSize;

  const GenericPagedGridView({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    required this.gridDelegate,
    this.pageSize = 20,
  });

  @override
  State<GenericPagedGridView<T>> createState() =>
      _GenericPagedGridViewState<T>();
}

class _GenericPagedGridViewState<T> extends State<GenericPagedGridView<T>> {
  late final PagingController<int, T> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, T>(firstPageKey: 1);
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await widget.fetchPage(pageKey);
      final items = response.data ?? [];

      final isLastPage =
          response.pagination?.currentPage == response.pagination?.totalPages;

      if (isLastPage) {
        _pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(items, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void refresh() => _pagingController.refresh();

  @override
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedGridView<int, T>(
        pagingController: _pagingController,
        gridDelegate: widget.gridDelegate,
        padding: const EdgeInsets.all(8),
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: widget.itemBuilder,
          firstPageErrorIndicatorBuilder: (_) =>
              const Center(child: Text('Error loading items')),
          newPageErrorIndicatorBuilder: (_) =>
              const Center(child: Text('Error loading more items')),
          noItemsFoundIndicatorBuilder: (_) =>
              const Center(child: Text('No items found')),
        ),
      ),
    );
  }
}
