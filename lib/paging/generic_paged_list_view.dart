import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:Tosell/paging/generic_paged_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GenericPagedListView<T> extends ConsumerStatefulWidget {
  final ItemBuilder<T> itemBuilder;
  final Future<ApiResponse<T>> Function(int pageKey, dynamic filter) fetchPage;
  final int pageSize;
  Widget? noItemsFoundIndicatorBuilder;
  Widget? newPageErrorIndicatorBuilder;
  Widget? firstPageErrorIndicatorBuilder;
  final dynamic filter;

  GenericPagedListView({
    super.key,
    required this.itemBuilder,
    required this.fetchPage,
    this.pageSize = 20,
    this.noItemsFoundIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.filter,
  });

  @override
  ConsumerState<GenericPagedListView<T>> createState() =>
      _GenericPagedListViewState<T>();
}

class _GenericPagedListViewState<T>
    extends ConsumerState<GenericPagedListView<T>> {
  late final PagingController<int, T> _pagingController;
  late dynamic _currentFilter;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener(_fetchPage);
    _currentFilter = widget.filter;
  }

  @override
  void didUpdateWidget(covariant GenericPagedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      _currentFilter = widget.filter;
      _pagingController.refresh();
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await widget.fetchPage(pageKey, _currentFilter);
      final items = response.getList;

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedListView<int, T>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: widget.itemBuilder,
          firstPageErrorIndicatorBuilder: (_) =>
              widget.firstPageErrorIndicatorBuilder ??
              const Center(child: Text('Error loading items')),
          newPageErrorIndicatorBuilder: (_) =>
              widget.newPageErrorIndicatorBuilder ??
              const Center(child: Text('Error loading more items')),
          noItemsFoundIndicatorBuilder: (_) =>
              widget.noItemsFoundIndicatorBuilder ??
              const Center(child: Text('No items found')),
        ),
      ),
    );
  }
}
