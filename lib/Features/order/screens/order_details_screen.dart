import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/core/widgets/custom_section.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/core/widgets/custom_phoneNumbrt.dart';
import 'package:Tosell/Features/orders/models/order_enum.dart';
import 'package:Tosell/Features/order/screens/order_state_bottom_sheet.dart';
import 'package:Tosell/Features/order/providers/order_commands_provider.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String code;
  const OrderDetailsScreen({super.key, required this.code});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  int handelProductState(int state) {
    return state;
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(getOrderByCodeProvider(widget.code));

    return Scaffold(
      
      body: orderAsync.when(
        data: (order) => buildUi(context, order),
        error: (error, stack) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildUi(BuildContext context, Order? order) {
    if (order == null) {
      return const Center(child: Text('لايوجد طلب بهذا الكود '));
    }
    var date = DateTime.parse(order.creationDate!);

    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomAppBar(
          title: "تفاصيل الطلب",
          showBackButton: true,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomSection(
                  title: "معلومات الطلب",
                  icon: SvgPicture.asset(
                    "assets/svg/Receipt.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  childrenRadius: const BorderRadius.all(Radius.circular(16)),
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("رقم الطلب", "assets/svg/User.svg",
                              Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(order.code ?? 'لايوجد')),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "حالة الطلب",
                            "assets/svg/SpinnerGap.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: Container(
                              width: 100,
                              height: 26,
                              decoration: BoxDecoration(
                                color: orderStatus[
                                        handelProductState(order.status!)]
                                    .color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  orderStatus[handelProductState(order.status!)]
                                          .name ??
                                      'لايوجد',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("التاريخ",
                              "assets/svg/CalendarBlank.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(
                                  "${date.day}.${date.month}.${date.year}")),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "السعر",
                            "assets/svg/coines.svg",
                            iconWidth: 20,
                            iconHight: 20,
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            subWidget:
                                Text(order.amount?.toString() ?? "لايوجد"),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("الحجم",
                              "assets/svg/CalendarBlank.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(order.size == null
                                  ? "لايوجد"
                                  : orderSizes[order.size!].name!)),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "الحالة",
                            "assets/svg/dollar.svg",
                            // iconWidth: 20,
                            // iconHight: 20,
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget:
                                Text(order.isPaid! ? "مدفوع" : 'غير مدفوع'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomSection(
                  title: "معلومات الزبون",
                  icon: SvgPicture.asset(
                    "assets/svg/User.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  childrenRadius: const BorderRadius.all(Radius.circular(16)),
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("أسم الزبون",
                              "assets/svg/UserCircle.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(order.customerName ?? "لايوجد")),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "رقم الهاتف",
                            "assets/svg/Phone.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: Text(
                              customPhoneNumber(
                                  order.customerPhoneNumber ?? "لايوجد"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("المحافظة",
                              "assets/svg/MapPinLine.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(
                                  order.deliveryZone?.governorate?.name ??
                                      "لايوجد")),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "المنطقة",
                            "assets/svg/MapPinArea.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget:
                                Text(order.deliveryZone?.name ?? "لايوجد"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                buildProductInfo(
                  content: order.content ?? 'لايوجد',
                  context,
                ), // You might want to pass the index or product

                _buildOrderState(
                    context,
                    orderStatus[handelProductState(order.status!)],
                    order.status!),
                const Gap(AppSpaces.medium),
                Container(
                  padding: AppSpaces.allMedium,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: FillButton(
                    label: "تواصل مع الدعم الفني",
                    onPressed: () {},
                    reverse: true,
                    icon: SvgPicture.asset(
                      "assets/svg/support.svg",
                      color: Colors.white,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  CustomSection buildProductInfo(BuildContext context,
      {required String content}) {
    return CustomSection(
      title: "معلومات المنتج",
      icon: SvgPicture.asset(
        "assets/svg/box.svg",
        color: Theme.of(context).colorScheme.primary,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      childrenRadius: const BorderRadius.all(Radius.circular(16)),
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildOrderSection(
                "تفاصيل المنتج",
                "assets/svg/Cards.svg",
                Theme.of(context),
                padding: const EdgeInsets.only(bottom: 3, top: 3),
                subWidget: Text(content),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderState(BuildContext context, OrderEnum state, int index) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // Remove isScrollControlled or keep it only if you really need scrolling
        builder: (BuildContext context) {
          return SizedBox(
            height: 660,
            child: OrderStateBottomSheet(
              state: index,
            ),
          );
        },
      ),
      child: CustomSection(
        title: "حالة الطلب",
        icon: SvgPicture.asset(
          'assets/svg/ArrowsDownUp.svg',
          color: Theme.of(context).colorScheme.primary,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        state.icon!,
                        color: context.colorScheme.primary,
                      )),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.name!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: context.colorScheme.primary,
                        fontFamily: "Tajawal",
                      ),
                    ),
                    Text(
                      state.description!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: "Tajawal",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildOrderSection(
  String title,
  String iconPath,
  ThemeData theme, {
  double? height,
  void Function()? onTap,
  EdgeInsets? padding,
  double? iconHight,
  double? iconWidth,
  Widget? subWidget,
}) {
  return Expanded(
    child: SizedBox(
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: SvgPicture.asset(
                  iconPath,
                  width: iconWidth ?? 24,
                  height: iconHight ?? 24,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                        fontFamily: "Tajawal",
                      ),
                    ),
                    if (subWidget != null) subWidget
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
