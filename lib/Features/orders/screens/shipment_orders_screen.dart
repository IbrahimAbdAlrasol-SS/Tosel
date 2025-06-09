import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/Features/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/orders/widgets/order_card_item.dart';
import 'package:Tosell/Features/orders/providers/orders_provider.dart';
import 'package:Tosell/paging/generic_paged_list_view.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  @override
  void initState() {
    super.initState();
    _fetchShipmentOrders();
  }

  void _fetchShipmentOrders() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersNotifierProvider.notifier).getAll(
        page: 1,
        queryParams: OrderFilter(
          shipmentId: widget.shipmentId,
        ).toJson(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
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
                          style: context.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.shipmentCode != null)
                          Text(
                            'رقم الشحنة: ${widget.shipmentCode}',
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.secondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Orders List
            Expanded(
              child: ordersState.when(
                data: (orders) => _buildOrdersList(orders),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('حدث خطأ: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> allOrders) {
    // Filter orders that belong to this shipment
    // Since we don't have shipmentId in Order model, we'll use the API filter
    // The filtered data should come from the API based on queryParams
    
    if (allOrders.isEmpty) {
      return _buildNoOrdersFound();
    }

    return GenericPagedListView<Order>(
      key: ValueKey(widget.shipmentId),
      noItemsFoundIndicatorBuilder: _buildNoOrdersFound(),
      fetchPage: (pageKey, _) async {
        return await ref.read(ordersNotifierProvider.notifier).getAll(
          page: pageKey,
          queryParams: OrderFilter(
            shipmentId: widget.shipmentId,
          ).toJson(),
        );
      },
      itemBuilder: (context, order, index) => OrderCardItem(
        order: order,
        onTap: () => context.push(AppRoutes.orderDetails, extra: order.id),
      ),
    );
  }

  Widget _buildNoOrdersFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/svg/NoItemsFound.gif',
            width: 200,
            height: 200,
          ),
          const Gap(AppSpaces.medium),
          Text(
            'لا توجد طلبات في هذه الشحنة',
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.error,
            ),
          ),
          const Gap(AppSpaces.small),
          Text(
            'يبدو أن هذه الشحنة فارغة',
            style: context.textTheme.bodyLarge!.copyWith(
              color: context.colorScheme.secondary,
            ),
          ),
          const Gap(AppSpaces.large),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FillButton(
              label: 'العودة للشحنات',
              onPressed: () => context.pop(),
              icon: Icon(
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