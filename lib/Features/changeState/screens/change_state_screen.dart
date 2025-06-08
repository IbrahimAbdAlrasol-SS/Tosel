import 'dart:collection';

import 'package:Tosell/Features/order/providers/order_commands_provider.dart';
import 'package:Tosell/Features/order/screens/order_state_bottom_sheet.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/Features/orders/models/order_enum.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/utils/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/OutlineButton.dart';
import 'package:Tosell/core/widgets/custom_phoneNumbrt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/custom_section.dart';
import 'package:go_router/go_router.dart';

class ChangeStateScreen extends ConsumerStatefulWidget {
  final String code;
  const ChangeStateScreen({super.key, required this.code});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeStateScreenState();
}

class _ChangeStateScreenState extends ConsumerState<ChangeStateScreen> {
  bool isButtonLoading = false;
  HashSet<String> selectedIds = HashSet();
  int handelProductState(int state) {
    return state;
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(getOrderByCodeProvider(widget.code));

    return Scaffold(
      body: orderAsync.when(
        data: (order) => buildUi(context, order),
        error: (error, stack) => _buildCodeNotFound(error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildUi(BuildContext context, Order? order) {
    if (order == null) {
      return const Center(child: Text('لايوجد طلب بهذا الكود '));
    }
    if (order.status! >= 9) {
      return const Center(child: Text('الطلب مكتمل لايمكنك تعديل الحالة'));
    }
    var date = DateTime.parse(order.creationDate!);

    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomAppBar(
          title: "تفاصيل الطلب",
          showBackButton: false,
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
                                color: const Color(0xFFF8F5FF),
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
                            "assets/svg/MapPinArea.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
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
                          // buildOrderSection(
                          //   "الفئة",
                          //   "assets/svg/MapPinArea.svg",
                          //   Theme.of(context),
                          //   padding: const EdgeInsets.only(bottom: 3, top: 3),
                          //   subWidget: Text(
                          //       order.category == null || order.category == ""
                          //           ? "لايوجد"
                          //           : order.category!),
                          // ),
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
                              subWidget:
                                  Text(order.deliveryZone?.name ?? "لايوجد")),
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
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics:
                //       const NeverScrollableScrollPhysics(), // Prevents conflict with the parent scroll
                //   itemCount: order.products?.length ?? 0,
                // itemBuilder: (context, index) =>
                buildProductInfo(
                  isSelect: false,
                  context,
                  content: order.content ?? "لايوجد",
                  selectAble: order.status == 5,
                ),
                _buildOrderState(
                    context,
                    orderStatus[handelProductState(order.status!)],
                    order.status!),
                _buildOrderState(
                    context,
                    title: 'حالة الطلب القادمة',
                    orderStatus[handelProductState(order.status! + 1)],
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
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedCustomButton(
                          borderColor: Theme.of(context).colorScheme.outline,
                          label: "غلق",
                          textColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            context.go(AppRoutes.home);
                          },
                        ),
                      ),
                      const Gap(AppSpaces.medium),
                      Expanded(
                        child: FillButton(
                          color: Theme.of(context).colorScheme.primary,
                          label: "تاكيد التغيير",
                          isLoading: isButtonLoading,
                          onPressed: () async {
                            Order? result;
                            String? error;
                            changeLoadingState(true);
                            try {
                              (result, error) = await ref
                                  .read(orderCommandsNotifierProvider.notifier)
                                  .changeOrderState(code: widget.code);
                              changeLoadingState(false);
                            } catch (e) {
                              error = e.toString();
                              changeLoadingState(false);
                            }

                            if (result == null) {
                              GlobalToast.show(
                                message: error!,
                                backgroundColor: context.colorScheme.error,
                                textColor: Colors.white,
                              );
                            } else {
                              GlobalToast.show(
                                message: 'تمت العملية بنجاح',
                                backgroundColor: context.colorScheme.primary,
                                textColor: Colors.white,
                              );
                              context.go(AppRoutes.home);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Center _buildCodeNotFound(Object error) {
    return Center(
        child: Column(
      children: [
        const CustomTextFormField(
          label: "كود الطلب",
          hint: 'ادخل رقم الطلب يدويا رجاء',
        ),
        SvgPicture.asset(
          "assets/svg/notFound.svg",
          width: 200,
          height: 200,
        ),
      ],
    ));
  }

  void changeLoadingState(bool state) {
    setState(() {
      isButtonLoading = state;
    });
  }

  Widget buildProductInfo(BuildContext context,
      {required String content,
      required bool isSelect,
      required bool selectAble}) {
    return GestureDetector(
      onTap: () {
        if (selectAble) {
          setState(() {
            // if(selectedIds.contains(product.id))
            // {
            // selectedIds.remove(product.id!);

            // }else
            // selectedIds.add(product.id!);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelect
              ? context.colorScheme.primary
              : Colors.transparent, // Change color if selected
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          // border: Border.all(
          //   color: true
          //       ? Colors.blue
          //       : Colors.transparent, // Highlight border when selected
          // ),
        ),
        child: CustomSection(
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
                      "الاسم", "assets/svg/Cards.svg", Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content ?? "لايوجد")),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Gap(AppSpaces.small),
                  buildOrderSection(
                      "العدد", "assets/svg/BoundingBox.svg", Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content ?? "لايوجد")),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildOrderSection(
                      "التكلفة", "assets/svg/Cards.svg", Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content ?? "لايوجد")),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Gap(AppSpaces.small),
                  buildOrderSection("حالة المنتج", "assets/svg/BoundingBox.svg",
                      Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderState(BuildContext context, OrderEnum state, int index,
      {String title = "حالة الطلب"}) {
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
        title: title,
        icon: SvgPicture.asset(
          'assets/svg/ArrowsDownUp.svg',
          color: Theme.of(context).colorScheme.primary,
        ),
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
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
                  Expanded(
                    child: Column(
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
                  ),
                ],
              ),
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
  void Function()? onTap,
  EdgeInsets? padding,
  Widget? subWidget,
}) {
  return Expanded(
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
                width: 24,
                height: 24,
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
  );
}
