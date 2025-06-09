import 'dart:ui';

import 'package:Tosell/Features/orders/widgets/shipment_cart_Item.dart';
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
import 'package:Tosell/Features/orders/models/Shipment.dart';
import 'package:Tosell/Features/orders/providers/shipments_provider.dart';
import 'package:Tosell/Features/orders/services/shipments_service.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  final OrderFilter? filter;
  const OrdersScreen({super.key, this.filter});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final int _selectedIndex = 0;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late OrderFilter? _currentFilter;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  // Multi-select states
  bool _isMultiSelectMode = false;
  final Set<String> _selectedOrderIds = {};
  List<Order> _allOrders = [];
  bool _isSelectAll = false;
  
  // Flag to track if initial data has been loaded
  bool _initialDataLoaded = false;
  
  // Flag to track if data has been loaded
  bool _dataLoaded = false;

  Future<void> _refresh() async {
    await ref.read(ordersNotifierProvider.notifier).getAll(
          page: 1,
          queryParams: widget.filter?.toJson(),
        );
  }

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.filter;
    _tabController = TabController(length: 2, vsync: this);
    _fetchInitialData();

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
        setState(() {
          _searchController.clear();
          // Exit multi-select mode when switching tabs
          if (_isMultiSelectMode) {
            _exitMultiSelectMode();
          }
        });
        // DO NOT fetch data on tab change
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
    if (_dataLoaded) return; // Prevent refetching if already loaded
    
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
      
      _dataLoaded = true; // Mark as loaded
    });
  }

  @override
  void didUpdateWidget(covariant OrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      _currentFilter = widget.filter ?? OrderFilter();
      _dataLoaded = false; // Reset flag to allow new fetch
      _fetchInitialData();
      _refresh();
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

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedOrderIds.clear();
        _isSelectAll = false;
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedOrderIds.clear();
      _isSelectAll = false;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _isSelectAll = !_isSelectAll;
      if (_isSelectAll) {
        // Select all visible orders
        _selectedOrderIds.clear();
        _selectedOrderIds.addAll(_allOrders.map((order) => order.id ?? ''));
      } else {
        // Deselect all
        _selectedOrderIds.clear();
      }
    });
  }

  void _toggleOrderSelection(String orderId) {
    print('Toggling order selection for ID: $orderId');
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
        _isSelectAll = false;
      } else {
        _selectedOrderIds.add(orderId);
        // Check if all orders are selected
        if (_selectedOrderIds.length == _allOrders.length) {
          _isSelectAll = true;
        }
      }
      print('Currently selected IDs: $_selectedOrderIds');
    });
  }

  Future<void> _sendShipment() async {
    print('=== Starting shipment creation ===');
    print('Selected order IDs: $_selectedOrderIds');
    
    if (_selectedOrderIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار طلب واحد على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
    );

    try {
      // Create shipment data according to API specification
      final orders = _selectedOrderIds.map((orderId) => {
        'orderId': orderId,
      }).toList();

      final shipmentData = {
        'delivered': false,
        'orders': orders,
      };
      
      print('Sending shipment data: $shipmentData');

      final shipmentsService = ShipmentsService();
      final result = await shipmentsService.createPickupShipment(shipmentData);
      
      print('Shipment result: ${result.$1}, Error: ${result.$2}');

      // Hide loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (result.$1 != null) {
        // Success
        print('Shipment created successfully!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الشحنة بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Exit multi-select mode
        _exitMultiSelectMode();

        // Reset data loaded flag and refresh
        _dataLoaded = false;
        _fetchInitialData();
      } else {
        // Error
        print('Shipment creation failed: ${result.$2}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.$2 ?? 'حدث خطأ في إنشاء الشحنة'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Exception during shipment creation: $e');
      print('Stack trace: $stackTrace');
      
      // Hide loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpaces.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add back button if viewing shipment orders
                  if (_currentFilter?.shipmentId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'طلبات الشحنة ${_currentFilter?.shipmentCode ?? ""}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
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
                      const Gap(AppSpaces.exSmall),
                      // Multi-Select Icon
                      GestureDetector(
                        onTap: _tabController.index == 0 ? _toggleMultiSelectMode : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _isMultiSelectMode
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isMultiSelectMode
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.checklist_rounded,
                                color: _isMultiSelectMode
                                    ? Colors.white
                                    : (_tabController.index == 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.secondary),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Filter Icon
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
                  const Gap(AppSpaces.exSmall),

                  // Tab Bar or Multi-Select Options
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isMultiSelectMode
                        ? _buildMultiSelectOptions()
                        : _buildTabBar(),
                  ),

                  const Gap(AppSpaces.small),

                  // Title based on active tab
                  if (!_isMultiSelectMode)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _tabController.index == 0
                            ? (_currentFilter == null || (_currentFilter!.status == null && _currentFilter!.shipmentId == null)
                                ? 'جميع الطلبات'
                                : _currentFilter!.shipmentCode != null
                                    ? 'طلبات الشحنة "${_currentFilter!.shipmentCode}"'
                                    : _currentFilter!.shipmentId != null
                                        ? 'طلبات الشحنة'
                                        : 'جميع الطلبات "${orderStatus[_currentFilter!.status!].name}"')
                            : (_currentFilter == null || _currentFilter!.status == null
                                ? 'جميع الوصولات'
                                : 'جميع الوصولات "${orderStatus[_currentFilter!.status!].name}"'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

                  // Tab Bar View
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: _isMultiSelectMode 
                          ? const NeverScrollableScrollPhysics() 
                          : const PageScrollPhysics(), // Changed to PageScrollPhysics
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

            // Bottom Send Shipment Button
            if (_isMultiSelectMode && _selectedOrderIds.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: FillButton(
                    label: 'إرسال شحنة (${_selectedOrderIds.length})',
                    onPressed: _sendShipment,
                    icon: Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200), // Faster animation
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _tabController.index == 0
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _tabController.index == 0
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'طلبات',
                    style: TextStyle(
                      color: _tabController.index == 0 ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200), // Faster animation
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _tabController.index == 1
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _tabController.index == 1
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'شحنات',
                    style: TextStyle(
                      color: _tabController.index == 1 ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'تم اختيار ${_selectedOrderIds.length} طلب',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: _toggleSelectAll,
                child: Text(
                  _isSelectAll ? 'إلغاء الكل' : 'اختيار الكل',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(8),
              IconButton(
                onPressed: _exitMultiSelectMode,
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final ordersState = ref.watch(ordersNotifierProvider);

    return ordersState.when(
      data: (data) {
        _allOrders = data;
        print('Loaded ${data.length} orders');
        data.forEach((order) {
          print('Order ID: ${order.id}, Code: ${order.code}');
        });
        return _buildOrdersList(data);
      },
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
    // Filter orders by shipmentId if provided
    final filteredData = _currentFilter?.shipmentId != null
        ? data.where((order) => 
            // You'll need to add shipmentId field to Order model
            // For now, this is a placeholder
            true // Replace with: order.shipmentId == _currentFilter?.shipmentId
          ).toList()
        : data;
        
    return Expanded(
      child: GenericPagedListView(
        key: ValueKey('${widget.filter?.toJson()}_${_tabController.index}'),
        noItemsFoundIndicatorBuilder: _buildNoOrdersFound(),
        fetchPage: (pageKey, _) async {
          return await ref.read(ordersNotifierProvider.notifier).getAll(
                page: pageKey,
                queryParams: _currentFilter?.toJson(),
              );
        },
        itemBuilder: (context, order, index) => _isMultiSelectMode
            ? _buildSelectableOrderCard(order)
            : OrderCardItem(
                order: order,
                onTap: () => context.push(AppRoutes.orderDetails, extra: order.id),
              ),
      ),
    );
  }

  Widget _buildSelectableOrderCard(Order order) {
    final isSelected = _selectedOrderIds.contains(order.id);
    
    return GestureDetector(
      onTap: () => _toggleOrderSelection(order.id ?? ''),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 0.95 : 1.0,
              child: OrderCardItem(
                order: order,
                onTap: () => _toggleOrderSelection(order.id ?? ''),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShipmentsList(List<Shipment> data) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refresh,
        child: GenericPagedListView(
          noItemsFoundIndicatorBuilder: _buildNoShipmentsFound(),
          fetchPage: (pageKey, _) async {
            return await ref.read(shipmentsNotifierProvider.notifier).getAll(
                  page: pageKey,
                  queryParams: widget.filter?.toJson(),
                );
          },
          itemBuilder: (context, shipment, index) => ShipmentCartItem(
            shipment: shipment,
            onTap: () {
              // Navigate to orders screen with shipment filter
              context.push(
                AppRoutes.orders,
                extra: OrderFilter(
                  shipmentId: shipment.id,
                  shipmentCode: shipment.code,
                ),
              );
            },
          ),
        ),
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