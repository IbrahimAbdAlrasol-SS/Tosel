import 'package:Tosell/Features/orders/models/Shipment.dart';
import 'package:Tosell/Features/orders/providers/shipments_provider.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/paging/generic_paged_list_view.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/Features/orders/models/order_enum.dart';
import 'package:Tosell/Features/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/orders/widgets/order_card_item.dart';
import 'package:Tosell/Features/orders/providers/orders_provider.dart';
import 'package:Tosell/Features/orders/screens/orders_filter_bottom_sheet.dart';
// Import for shipments
import 'package:Tosell/Features/shipments/models/Shipment.dart';
import 'package:Tosell/Features/shipments/providers/shipments_provider.dart';

class MainOrdersWithTabsScreen extends ConsumerStatefulWidget {
  final OrderFilter? filter;
  const MainOrdersWithTabsScreen({super.key, this.filter});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainOrdersWithTabsScreenState();
}

class _MainOrdersWithTabsScreenState extends ConsumerState<MainOrdersWithTabsScreen>
    with SingleTickerProviderStateMixin {
  late OrderFilter? _currentFilter;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.filter;
    _tabController = TabController(length: 2, vsync: this);
    _fetchInitialData();
    
    // Listen to tab changes to update search hint
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _searchController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch orders
      ref.read(ordersNotifierProvider.notifier).getAll(
        page: 1,
        queryParams: _currentFilter?.toJson(),
      );
      // Fetch shipments
      ref.read(shipmentsNotifierProvider.notifier).getAll(
        page: 1,
        queryParams: _currentFilter?.toJson(),
      );
    });
  }

  @override
  void didUpdateWidget(covariant MainOrdersWithTabsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      _currentFilter = widget.filter ?? OrderFilter();
      _fetchInitialData();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => const OrdersFilterBottomSheet(),
    ).then((result) {
      if (result != null && result is OrderFilter) {
        setState(() {
          _currentFilter = result;
        });
        _fetchInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpaces.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and Filter Row
              Row(
                children: [
                  const Gap(10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _searchController,
                      label: '',
                      showLabel: false,
                      hint: _tabController.index == 0 ? 'رقم الطلب' : 'رقم الوصل',
                      prefixInner: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/svg/search.svg',
                          color: Theme.of(context).colorScheme.primary,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      onChanged: (value) {
                        // TODO: Implement search functionality
                      },
                    ),
                  ),
                  const Gap(AppSpaces.medium),
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _currentFilter?.status == null
                                    ? Theme.of(context).colorScheme.outline
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/svg/Funnel.svg',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        if (_currentFilter != null && _currentFilter!.status != null)
                          Positioned(
                            top: 6,
                            right: 10,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(AppSpaces.medium),
              
              // Tab Bar
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'طلبات'),
                    Tab(text: 'شحنات'),
                  ],
                ),
              ),
              
              const Gap(AppSpaces.small),
              
              // Title based on active tab
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _tabController.index == 0
                      ? (_currentFilter == null || _currentFilter!.status == null
                          ? 'جميع الطلبات'
                          : _currentFilter!.shipmentCode != null 
                              ? 'جميع الطلبات "${_currentFilter!.shipmentCode}"'
                              : 'جميع الطلبات "${orderStatus[_currentFilter!.status!].name}"')
                      : (_currentFilter == null || _currentFilter!.status == null
                          ? 'جميع الوصولات'
                          : 'جميع الوصولات "${orderStatus[_currentFilter!.status!].name}"'),
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Orders Tab
                    _buildOrdersTab(),
                    // Shipments Tab
                    _buildShipmentsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    final ordersState = ref.watch(ordersNotifierProvider);
    
    return ordersState.when(
      data: (data) => _buildOrdersList(data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text(err.toString())),
    );
  }

  Widget _buildShipmentsTab() {
    final shipmentsState = ref.watch(shipmentsNotifierProvider);
    
    return shipmentsState.when(
      data: (data) => _buildShipmentsList(data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text(err.toString())),
    );
  }

  Widget _buildOrdersList(List<Order> data) {
    return GenericPagedListView(
      key: ValueKey('orders_${_currentFilter?.toJson()}'),
      noItemsFoundIndicatorBuilder: _buildNoOrdersFound(),
      fetchPage: (pageKey, _) async {
        return await ref.read(ordersNotifierProvider.notifier).getAll(
          page: pageKey,
          queryParams: _currentFilter?.toJson(),
        );
      },
      itemBuilder: (context, order, index) => OrderCardItem(
        order: order,
        onTap: () => context.push(AppRoutes.orderDetails, extra: order.code),
      ),
    );
  }

  Widget _buildShipmentsList(List<Shipment> data) {
    return GenericPagedListView(
      key: ValueKey('shipments_${_currentFilter?.toJson()}'),
      noItemsFoundIndicatorBuilder: _buildNoShipmentsFound(),
      fetchPage: (pageKey, _) async {
        return await ref.read(shipmentsNotifierProvider.notifier).getAll(
          page: pageKey,
          queryParams: _currentFilter?.toJson(),
        );
      },
      itemBuilder: (context, shipment, index) => OrderCardItem(
        order: Order(
          id: shipment.id,
          code: shipment.code,
          status: shipment.status,
          creationDate: shipment.creationDate,
          customerName: 'وصل ${shipment.code}',
          content: 'عدد الطلبات: ${shipment.ordersCount ?? 0}',
          deliveryZone: null,
        ),
        onTap: () => context.push(AppRoutes.orders,
            extra: OrderFilter(
                shipmentId: shipment.id, 
                shipmentCode: shipment.code
            )),
      ),
    );
  }

  Widget _buildNoOrdersFound() {
    return Column(
      children: [
        Image.asset('assets/svg/NoItemsFound.gif', width: 240, height: 240),
        Text(
          'لا توجد طلبات مضافة',
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xffE96363),
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'اضغط على زر "جديد" لإضافة طلب جديد و ارساله الى زبونك',
          style: context.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: const Color(0xff698596),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: FillButton(
            label: 'إضافة اول طلب',
            onPressed: () => context.push(AppRoutes.addOrder),
            icon: SvgPicture.asset('assets/svg/navigation_add.svg',
                color: const Color(0xffFAFEFD)),
            reverse: true,
          ),
        )
      ],
    );
  }

  Widget _buildNoShipmentsFound() {
    return Column(
      children: [
        Image.asset(
          'assets/svg/NoItemsFound.gif',
          width: 240,
          height: 240,
        ),
        const Gap(AppSpaces.medium),
        Text(
          'لاتوجد وصولات',
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.primary,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}