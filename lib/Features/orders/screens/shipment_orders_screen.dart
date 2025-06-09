import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/Features/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/orders/models/order_enum.dart';
import 'package:Tosell/Features/orders/widgets/order_card_item.dart';
import 'package:Tosell/Features/orders/providers/orders_provider.dart';
import 'package:Tosell/Features/orders/services/orders_service.dart';

class ShipmentOrdersScreen extends ConsumerStatefulWidget {
  final String shipmentId;
  final String? shipmentCode;
  
  const ShipmentOrdersScreen({
    super.key,
    required this.shipmentId,
    this.shipmentCode,
  });

  @override
  ConsumerState<ShipmentOrdersScreen> createState() => _ShipmentOrdersScreenState();
}

class _ShipmentOrdersScreenState extends ConsumerState<ShipmentOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;
  final OrdersService _ordersService = OrdersService();

  @override
  void initState() {
    super.initState();
    _loadShipmentOrders();
  }

  Future<void> _loadShipmentOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _ordersService.getOrders(
        queryParams: OrderFilter(
          shipmentId: widget.shipmentId,
        ).toJson(),
      );

      setState(() {
        _orders = response.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
              // Header with back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طلبات الشحنة',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.shipmentCode != null)
                            Text(
                              'رقم الشحنة: ${widget.shipmentCode}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Gap(AppSpaces.medium),
              
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _searchController,
                        label: '',
                        showLabel: false,
                        hint: 'رقم الطلب',
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
                          setState(() {
                            // Filter orders based on search
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const Gap(AppSpaces.medium),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'جميع طلبات الشحنة (${_orders.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const Gap(AppSpaces.small),
              
              // Orders list
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const Gap(AppSpaces.small),
            Text(_error!),
            const Gap(AppSpaces.medium),
            FillButton(
              label: 'إعادة المحاولة',
              onPressed: _loadShipmentOrders,
            ),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return _buildNoOrdersFound();
    }

    // Filter orders based on search
    final filteredOrders = _searchController.text.isEmpty
        ? _orders
        : _orders.where((order) =>
            order.code?.contains(_searchController.text) ?? false).toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return OrderCardItem(
          order: order,
          onTap: () => context.push(AppRoutes.orderDetails, extra: order.id),
        );
      },
    );
  }

  Widget _buildNoOrdersFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/svg/NoItemsFound.gif',
            width: 240,
            height: 240,
          ),
          const Gap(AppSpaces.medium),
          Text(
            'لا توجد طلبات في هذه الشحنة',
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xffE96363),
            ),
          ),
          const Gap(AppSpaces.small),
          Text(
            'يبدو أن هذه الشحنة فارغة',
            style: context.textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const Gap(AppSpaces.large),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FillButton(
              label: 'العودة',
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}