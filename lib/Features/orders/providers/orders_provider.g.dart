// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ordersNotifierHash() => r'203ad63a7ea09ed3f32864a56a1c3ae6843a9a4b';

/// See also [OrdersNotifier].
@ProviderFor(OrdersNotifier)
final ordersNotifierProvider =
    AutoDisposeAsyncNotifierProvider<OrdersNotifier, List<Order>>.internal(
  OrdersNotifier.new,
  name: r'ordersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrdersNotifier = AutoDisposeAsyncNotifier<List<Order>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
